require 'rails_helper'

RSpec.describe PreservationsController, type: :controller do
  let(:valid_attributes) { { initial_file_link: 'https://example.com/file.pdf' } }
  let(:invalid_attributes) { { initial_file_link: 'invalid-url' } }
  let(:preservation) { create(:preservation) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: preservation.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Preservation' do
        expect do
          post :create, params: { preservation: valid_attributes }
        end.to change(Preservation, :count).by(1)
      end

      it 'renders Turbo Stream updates (flash messages)' do
        post :create, params: { preservation: valid_attributes }

        expect(response.body).to include('<turbo-stream action="update" target="flash-messages">')
        expect(response.body).to include('<turbo-stream action="update" target="form-errors">')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Preservation' do
        expect do
          post :create, params: { preservation: invalid_attributes }
        end.not_to change(Preservation, :count)
      end

      it 'renders Turbo Stream updates with errors' do
        post :create, params: { preservation: invalid_attributes }

        expect(response.body).to include('<turbo-stream action="update" target="flash-messages">')
        expect(response.body).to include('<turbo-stream action="update" target="form-errors">')
      end
    end
  end
end
