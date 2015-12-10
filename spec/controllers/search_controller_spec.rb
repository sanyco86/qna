require 'rails_helper'

RSpec.describe SearchController, :type => :controller do
  describe 'GET #search' do
    it 'receives #search method with everywhere condition' do
      expect(Question).to receive(:search).with('nothing')
      get :search, search: { query: 'nothing', conditions: 'everywhere' }
    end

    it 'receives #search method with questions condition' do
      expect(Question).to receive(:search).with({conditions: { title: 'nothing', body: 'nothing' } })
      get :search, search: { query: 'nothing', conditions: 'questions' }
    end

    it 'receives #search method with answers condition' do
      expect(Question).to receive(:search).with({conditions: { 'answers' => 'nothing' } })
      get :search, search: { query: 'nothing', conditions: 'answers' }
    end

    it 'receives #search method with comments condition' do
      expect(Question).to receive(:search).with({conditions: { 'comments' => 'nothing' } })
      get :search, search: { query: 'nothing', conditions: 'comments' }
    end

    it 'receives #search method with users condition' do
      expect(Question).to receive(:search).with({conditions: { 'users' => 'nothing' } })
      get :search, search: { query: 'nothing', conditions: 'users' }
    end
  end
end
