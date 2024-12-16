class FileUploadService
  require 'net/http'
  require 'uri'
  require 'json'
  require 'action_dispatch'

  attr_reader :preservation

  BASE_URI = 'https://file.io'.freeze

  def initialize(preservation)
    @preservation = preservation
  end

  def call
    preservation.update(logs: append_log("Upload process started for preservation ##{preservation.id}"))

    begin
      if preservation.initial_file.blank?
        preservation.update(status: :upload_failed, logs: append_log('Initial file not attached, cannot upload.'))
        return
      end

      upload_file(preservation.initial_file)
    rescue StandardError => e
      preservation.update(status: :upload_failed, logs: append_log("Error in upload process: #{e.message}"))
    end
  end

  private

  def upload_file(file)
    file_path = file.path

    unless File.exist?(file_path)
      preservation.update(logs: append_log("File not found at path: #{file_path}"))
      raise "File not found at path: #{file_path}"
    end

    filename = preservation.name_of_initial_file || File.basename(file_path)

    uri = URI.parse(BASE_URI)
    request = Net::HTTP::Post.new(uri)

    request['Content-Type'] = 'multipart/form-data'

    boundary = "----WebKitFormBoundary#{SecureRandom.hex(16)}"
    request['Content-Type'] = "multipart/form-data; boundary=#{boundary}"

    file_content = File.binread(file_path)

    body = []
    body << "--#{boundary}\r\n"
    body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{filename}\"\r\n"
    body << "Content-Type: application/octet-stream\r\n\r\n"
    body << file_content
    body << "\r\n--#{boundary}--\r\n"
    request.body = body.join

    response = send_request(uri, request)
    handle_response(response)
  end

  def send_request(uri, request)
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end

  def handle_response(response)
    case response.code.to_i
    when 200
      json_response = JSON.parse(response.body)
      if json_response['success']
        preservation.update(preserved_file_link: json_response['link'], status: :preservation_finished)
        append_log("File uploaded successfully: #{json_response['link']}")
      else
        preservation.update(status: :upload_failed, logs: append_log("File upload failed: #{response.body}"))
      end
    else
      preservation.update(status: :upload_failed, logs: append_log("File upload failed with status code: #{response.code}"))
    end
  end

  def append_log(message)
    current_logs = preservation.logs || ''
    timestamp = Time.current.strftime('%Y-%m-%d %H:%M:%S')
    "#{current_logs} [#{timestamp}] #{message}\n\n"
  end
end
