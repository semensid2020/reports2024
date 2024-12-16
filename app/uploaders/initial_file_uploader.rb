class InitialFileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/preservations/#{model.id}/initial_files"
  end

  def extension_white_list
    %w[jpg jpeg gif png pdf docx]
  end
end
