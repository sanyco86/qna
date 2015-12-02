shared_examples_for 'Api Authenticable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if there is invalid acces token' do
      do_request(access_token: 1234)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'successfully reponsible' do
  it 'returns 200 status' do
    expect(response).to be_success
  end
end