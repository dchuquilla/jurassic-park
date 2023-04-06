require 'rails_helper'

RSpec.describe 'Api::V1::CagesController', type: :request do
  describe 'GET /api/v1/cages' do
    let!(:cages) { create_list(:cage, 3) }

    before { get '/api/v1/cages' }

    it 'returns cages' do
      expect(cages).not_to be_empty
      expect(cages.size).to eq(3)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all the cages' do
      expect(cages.map { |cage| cage['id'] }).to match_array(cages.map(&:id))
    end
  end

  describe 'GET #show' do
    let!(:cage) { create(:cage) }

    context 'when the cage exists' do
      before { get "/api/v1/cages/#{cage.id}" }

      it 'returns the cage' do
        expect(cage).not_to be_nil
        expect(cage['id']).to eq(cage.id)
        expect(cage['name']).to eq(cage.name)
        expect(cage['capacity']).to eq(cage.capacity)
      end

      it 'returns a status code of 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the cage does not exist' do
      before { get '/api/v1/cages/999' }

      it "returns a 'not found' message" do
        expect(response.body).to match(/Cage not found/)
      end

      it 'returns a status code of 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/cages' do
    context 'with valid parameters' do
      let(:valid_params) { attributes_for(:cage) }

      it 'creates a new cage' do
        expect do
          post '/api/v1/cages', params: { cage: valid_params }
        end.to change(Cage, :count).by(1)
      end

      it 'responds with a success status code' do
        post '/api/v1/cages', params: { cage: valid_params }
        expect(response).to have_http_status(:created)
      end

      it 'responds with the new cage in the body' do
        post '/api/v1/cages', params: { cage: valid_params }
        valid_params.each do |key, _value|
          expect(response.body).to include(key.to_s)
        end
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { name: nil, capacity: 1 } }

      it 'does not create a new cage' do
        expect do
          post '/api/v1/cages', params: { cage: invalid_params }
        end.to raise_exception(ActiveRecord::NotNullViolation)
      end

      it 'responds with an error status code' do
        expect do
          post '/api/v1/cages', params: { cage: invalid_params }
          response
        end.to raise_exception(ActiveRecord::NotNullViolation)
      end

      it 'responds with the validation errors in the body' do
        expect do
          post '/api/v1/cages', params: { cage: invalid_params }
          response.body
        end.to raise_exception(ActiveRecord::NotNullViolation)
      end
    end
  end

  describe 'PUT #update' do
    context 'when the cage exists' do
      let(:cage) { FactoryBot.create(:cage) }

      context 'when the update is valid' do
        let(:new_attributes) { { power_status: 'down' } }

        before do
          put "/api/v1/cages/#{cage.id}", params: { cage: new_attributes }
          cage.reload
        end

        it 'returns a success response' do
          expect(response).to be_successful
        end

        it 'updates the cage' do
          expect(cage.power_status).to eq('down')
        end
      end

      context 'when the update is invalid' do
        let(:new_attributes) { { capacity: -1 } }

        before do
          put "/api/v1/cages/#{cage.id}", params: { cage: new_attributes }
          cage.reload
        end

        it 'returns an error response' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not update the cage' do
          expect(cage.capacity).not_to eq(-1)
        end
      end
    end

    context 'when the cage does not exist' do
      it 'returns a not found response' do
        put '/api/v1/cages/99999', params: { power_status: 'down' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/cages/:id' do
    let!(:cage) { create(:cage) }

    context 'when the cage exists' do
      before { delete "/api/v1/cages/#{cage.id}" }

      it 'returns a success response' do
        expect(response).to have_http_status(:no_content)
      end

      it 'deletes the cage' do
        expect(Cage.exists?(cage.id)).to be_falsey
      end
    end

    context 'when the cage does not exist' do
      before { delete '/api/v1/cages/999' }

      it 'returns a not found error' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /api/v1/cages/:id/dinosaurs' do
    let!(:cage) { create(:cage) }
    let!(:tyrannosaurus) { create(:dinosaur, species: :TYRANNOSAURUS, cage: cage) }
    let!(:stegosaurus) { create(:dinosaur, species: :STEGOSAURUS, cage: cage) }
    let!(:triceratops) { create(:dinosaur, species: :TRICERATOPS) }

    context 'when the cage exists' do
      it 'returns a list of dinosaurs in the cage' do
        get "/api/v1/cages/#{cage.id}/dinosaurs"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(tyrannosaurus.to_json)
        expect(response.body).to include(stegosaurus.to_json)
        expect(response.body).not_to include(triceratops.to_json)
      end
    end

    context 'when the cage does not exist' do
      it 'returns a not found error' do
        get '/api/v1/cages/999/dinosaurs'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
