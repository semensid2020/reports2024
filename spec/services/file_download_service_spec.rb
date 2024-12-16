require 'rails_helper'

RSpec.describe FileDownloadService, type: :service do
  let(:preservation) { create(:preservation, initial_file_link: 'https://example.com/file.pdf') }
  let(:service) { FileDownloadService.new(preservation, 'initial') }

  before do
    allow(Net::HTTP).to receive(:get_response).and_return(double('response', is_a?: true, code: '200', body: 'OK', 'Content-Type' => 'application/pdf'))
    allow(URI).to receive(:open).and_return('file_content')
  end

  it 'successfully downloads and attaches a file' do
    service.call
    expect(preservation.status).to eq('initial_attaching_finished')
  end

  it 'logs an error when download fails' do
    allow(Net::HTTP).to receive(:get_response).and_return(double('response', is_a?: false, code: '404'))
    service.call
    expect(preservation.status).to eq('initial_download_failed')
  end
end
