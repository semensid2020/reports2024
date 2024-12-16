require 'rails_helper'

RSpec.describe RemoteFileVerificationService, type: :service do
  let(:preservation) { create(:preservation, preserved_file_link: 'https://file.io/abc123', initial_file: fixture_file_upload('spec/fixtures/files/test_file.pdf')) }
  let(:service) { RemoteFileVerificationService.new(preservation) }

  before do
    allow(Net::HTTP).to receive(:start).and_return(double('response', code: '200', body: '{"size": 13264, "name": "test_file.pdf"}', message: 'OK'))
  end

  it 'verifies the file successfully' do
    service.call

    expect(preservation.status).to eq('verification_finished')
  end

  it 'fails verification if metadata does not match' do
    allow(Net::HTTP).to receive(:start).and_return(double('response', code: '200', body: '{"size": 666, "name": "test_file.pdf"}', message: 'OK'))
    service.call

    expect(preservation.status).to eq('verification_failure')
  end

  it 'handles HTTP errors gracefully' do
    allow(Net::HTTP).to receive(:start).and_return(double('response', code: '500', body: '{"error": "Internal Server Error"}', message: 'Internal Server Error'))
    service.call

    expect(preservation.status).to eq('verification_failure')
    expect(preservation.logs).to include('Failed to fetch metadata from file.io: Internal Server Error')
  end
end
