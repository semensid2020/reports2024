# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  month           :integer          not null
#  report_file     :string
#  report_filename :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Report < ApplicationRecord
  belongs_to :user
  mount_uploader :report_file, ReportFileUploader
  after_create :intiate_document

  def intiate_document
    ReportConstructorJob.set(wait: 5.seconds).perform_later(self)
  end
end
