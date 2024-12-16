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
FactoryBot.define do
  factory :preservation do
    initial_file_link { 'https://example.com/file.pdf' }
    status { :pending }
    logs { '' }
  end
end
