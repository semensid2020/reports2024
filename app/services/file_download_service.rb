class FileDownloadService
  require 'net/http'
  require 'uri'
  require 'open-uri'

  attr_reader :preservation, :mode

  def initialize(preservation, mode)
    @preservation = preservation
    @mode = mode
  end

  def call
    mode_str = mode.dup
    preservation.update(logs: append_log("Preservation #{mode == 'initial' ? '' : mode_str.concat(' ')}initiated"))

    case mode
    when 'initial'
      url = URI.parse(preservation.initial_file_link)
    when 'verification'
      url = URI.parse(preservation.preserved_file_link)
    else
      preservation.update(status: :failed_unexpectedly, logs: append_log("Failed unexpectedly due to wrong execution mode: #{mode}"))

      return
    end

    begin
      response = Net::HTTP.get_response(url)

      if response.is_a?(Net::HTTPSuccess)
        filename = extract_filename(url, response)
        download_and_attach_file(url, filename)
      else
        preservation.update(status: "#{mode}_download_failed", logs: append_log("Failed to download #{mode} file: HTTP error #{response.code}"))
      end
    rescue StandardError => e
      preservation.update(status: "#{mode}_download_failed", logs: append_log("Error downloading #{mode} file: #{e.message}"))
    end
  end

  private

  def extract_filename(url, response)
    filename = if response['Content-Disposition']
                 response['Content-Disposition'].split('filename="').last.split('"').first
               else
                 File.basename(url.path)
               end
    filename.gsub(/[^0-9A-Za-z.\-]/, '_')
  end

  def download_and_attach_file(url, filename)
    uri = URI.parse(url)

    response = Net::HTTP.get_response(uri)
    content_type = response['Content-Type']
    Rails.logger.info("Content-Type: #{content_type}")

    if content_type.nil? || content_type.include?('text/html')
      preservation.update(status: "#{mode}_download_failed", logs: append_log('Invalid content at URL (expected a file but got a webpage).'))
      return
    end

    begin
      file_content = URI.open(url)

      if file_content.blank?
        preservation.update(status: "#{mode}_download_failed", logs: append_log('File is empty or invalid.'))
        return
      end

      file_content.rewind

      case mode
      when 'initial'
        preservation.update(name_of_initial_file: filename)
        preservation.initial_file.store!(file_content)
        preservation.update(status: :initial_attaching_finished, logs: append_log('Initial file downloaded and attached successfully.'))
      when 'verification'
        preservation.update(name_of_verification_file: filename)
        preservation.verification_file.cache!(file_content)
        preservation.update(status: :verification_attaching_finished, logs: append_log('Verification file downloaded and attached successfully.'))
      end
    rescue StandardError => e
      Rails.logger.error("Error downloading or attaching file: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))

      preservation.update(status: "#{mode}_attaching_failed", logs: append_log("Error downloading or attaching file: #{e.message}"))

      raise e
    end
  end

  def append_log(message)
    current_logs = preservation.logs || ''

    timestamp = Time.current.strftime('%Y-%m-%d %H:%M:%S')
    "#{current_logs} [#{timestamp}] #{message}\n\n"
  end
end
