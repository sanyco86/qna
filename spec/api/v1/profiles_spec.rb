require 'rails_helper'

describe 'Profiles API' do
  describe 'GET /' do
    it_behaves_like 'Api Authenticable'

    context 'authorized', :lurker do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 4) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it_behaves_like 'successfully reponsible'

      it 'contains array of users' do
        expect(response.body).to be_json_eql(users.to_json).at_path('profiles')
      end

      it 'doesnt contain current user' do
        expect(response.body).to_not include_json(me.to_json)
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', { format: :json }.merge(options)
    end
  end

  describe 'GET /me' do
    it_behaves_like 'Api Authenticable'

    context 'authorized', :lurker do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it_behaves_like 'successfully reponsible'

      %w(id email).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "doesnt contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end
end
