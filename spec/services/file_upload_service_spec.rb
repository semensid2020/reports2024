require 'rails_helper'

RSpec.describe FileUploadService, type: :service do
  let(:preservation) { create(:preservation, initial_file: fixture_file_upload('spec/fixtures/files/test_file.pdf')) }
  let(:service) { FileUploadService.new(preservation) }

  before do
    allow(Net::HTTP).to receive(:start).and_return(double('response', code: '200', body: '{"success": true, "link": "https://file.io/abc123"}', message: 'OK'))
  end

  it 'uploads the file successfully' do
    service.call

    expect(preservation.preserved_file_link).to eq('https://file.io/abc123')
  end

  it 'fails when the file does not exist' do
    allow(File).to receive(:exist?).and_return(false)
    service.call

    expect(preservation.status).to eq('upload_failed')
    expect(preservation.logs).to include('File not found at path:')
  end

  it 'handles errors in the upload process gracefully' do
    allow(Net::HTTP).to receive(:start).and_return(double('response', code: '500', body: '{"success": false, "message": "Internal Server Error"}'))
    service.call

    expect(preservation.status).to eq('upload_failed')
    expect(preservation.logs).to include('File upload failed with status code: 500')
  end

  it 'fails when the file cannot be uploaded due to missing file' do
    allow(preservation).to receive(:initial_file).and_return(nil)
    service.call

    expect(preservation.status).to eq('upload_failed')
    expect(preservation.logs).to include('Initial file not attached, cannot upload.')
  end
end
