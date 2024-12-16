class ReportFileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/reports/#{model.id}/report_files"
  end

  def extension_white_list
    %w[csv pdf]
  end
end
