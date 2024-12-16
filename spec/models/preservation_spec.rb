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
require 'rails_helper'

RSpec.describe Preservation, type: :model do
  it 'is valid with valid attributes' do
    preservation = build(:preservation)
    expect(preservation).to be_valid
  end

  it 'is not valid without an initial_file_link' do
    preservation = build(:preservation, initial_file_link: nil)
    expect(preservation).not_to be_valid
  end

  it 'is not valid with an invalid initial_file_link' do
    preservation = build(:preservation, initial_file_link: 'invalid-url')
    expect(preservation).not_to be_valid
  end

  describe 'callbacks' do
    before do
      allow(FileDownloadService).to receive(:new).and_return(double(call: true))
      allow(FileUploadService).to receive(:new).and_return(double(call: true))
      allow(RemoteFileVerificationService).to receive(:new).and_return(double(call: true))
    end

    let(:preservation) do
      create(:preservation, initial_file_link: 'http://example.com/file.pdf', preserved_file_link: 'http://file.io/abc123')
    end

    it 'triggers the start_initial_download callback after create' do
      preservation = create(:preservation, initial_file_link: 'http://example.com/file.pdf')
      expect(preservation.status).to eq('downloading_in_progress')
    end

    it 'triggers the trigger_upload_service callback after update to initial_attaching_finished' do
      preservation.update(status: :downloading_in_progress)
      preservation.update(status: :initial_attaching_finished)
      expect(preservation.status).to eq('uploading_in_progress')
    end

    it 'triggers the trigger_verification_service callback after update to preservation_finished' do
      preservation.update(status: :uploading_in_progress)
      preservation.update(status: :preservation_finished)
      expect(preservation.status).to eq('verification_in_progress')
    end
  end
end
