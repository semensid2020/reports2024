# == Schema Information
#
# Table name: preservations
#
#  id                        :bigint           not null, primary key
#  initial_file              :string
#  initial_file_link         :string           not null
#  logs                      :text
#  name_of_initial_file      :string
#  name_of_verification_file :string
#  preserved_file_link       :string
#  status                    :integer          default("pending"), not null
#  verification_file         :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class Preservation < ApplicationRecord
  validates :initial_file_link, presence: true, format: {
    with: %r{\A(http|https)://[\S]+\z},
    message: 'must be a valid URL starting with http:// or https://'
  }

  after_create :start_initial_download

  after_update :trigger_upload_service, if: -> { saved_change_to_status? && status == 'initial_attaching_finished' }

  # Планировалось, что данный коллбэк будет дергаться, чтобы повторно скачать файл уже с целевого "хранилища" File.io
  # т.е. протестиировать полностью метаданные + скачивание. Но т.к. сервис File.io после первого скачивания удаляет файл,
  # то пришлось отказаться от такой проверки. Альтернативный сервис не смог найти.
  # after_update :trigger_verification_mode, if: -> { saved_change_to_status? && status == 'preservation_finished' }

  # Поэтому заменено на более слабую проверку - просто по метаданным (без скачивания файла)
  after_update :trigger_verification_service, if: -> { saved_change_to_status? && status == 'preservation_finished' }

  ## Изначально скачиваемый файл
  mount_uploader :initial_file, InitialFileUploader

  ## Файл, скачиваемый уже для проверки корректности работы итоговой ссылки скачивания. Пришлось отказаться (см. коммент выше)
  # mount_uploader :verification_file, VerificationFileUploader

  enum :status, {
    pending: 0,
                  # Stage 1
                  downloading_in_progress: 1,
                  initial_download_failed: 2,
                  initial_attaching_failed: 3,
                  initial_attaching_finished: 4,
                  # Stage 2
                  uploading_in_progress: 5,
                  upload_failed: 6,
                  preservation_finished: 7,
                  # Stage 3
                  verification_in_progress: 8,
                  # verification_download_failed: 9,
                  # verification_attaching_failed: 10,
                  verification_failure: 11,
                  verification_finished: 12,
                  failed_unexpectedly: 13 # ,
    # deleted: 14
  }

  private

  def start_initial_download
    update(status: :downloading_in_progress)
    FileDownloadService.new(self, 'initial').call
  end

  def trigger_upload_service
    update(status: :uploading_in_progress)
    FileUploadService.new(self).call
  end

  # def trigger_verification_download
  #   update(status: :verification_in_progress)
  #   FileDownloadService.new(self, 'verification').call
  # end

  def trigger_verification_service
    update(status: :verification_in_progress)
    RemoteFileVerificationService.new(self).call
  end
end
