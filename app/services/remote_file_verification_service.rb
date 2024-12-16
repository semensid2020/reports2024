class RemoteFileVerificationService
  require 'net/http'
  require 'uri'
  require 'json'

  attr_reader :preservation

  BASE_URI = 'https://file.io/'.freeze

  def initialize(preservation)
    @preservation = preservation
  end

  def call
    preservation.update(logs: append_log("File verification started for preservation ##{preservation.id}"))

    begin
      # Extract the file key from the preserved file link (e.g., 'ewichaQ0wnh5' from 'https://file.io/ewichaQ0wnh5')
      file_key = preservation.preserved_file_link.split('/').last

      # Build the URL to fetch metadata
      metadata_url = URI.join(BASE_URI, "#{file_key}/metadata")

      # Make GET request to fetch metadata
      response = get_metadata(metadata_url)

      if response.is_a?(Net::HTTPSuccess)
        # Parse the JSON response
        metadata = JSON.parse(response.body)

        # Extract the file metadata
        file_size = metadata['size']
        file_name = metadata['name']

        # Compare the file metadata (size and name) with the initial file
        file_size_match = file_size == preservation.initial_file.size
        file_name_match = file_name == preservation.name_of_initial_file

        if file_size_match && file_name_match
          preservation.update(status: :verification_finished, logs: append_log('File verified successfully.'))
        else
          preservation.update(status: :verification_failure, logs: append_log('File verification failed. Metadata does not match.'))
        end
      else
        preservation.update(status: :verification_failure, logs: append_log("Failed to fetch metadata from file.io: #{response.message}"))
      end
    rescue StandardError => e
      preservation.update(status: :verification_failure, logs: append_log("Error during file verification: #{e.message}"))
      Rails.logger.error("Error during file verification: #{e.message}")
    end
  end

  private

  def get_metadata(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)

    # Send the GET request
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end

  def append_log(message)
    current_logs = preservation.logs || ''
    timestamp = Time.current.strftime('%Y-%m-%d %H:%M:%S')
    "#{current_logs} [#{timestamp}] #{message}\n\n"
  end
end
