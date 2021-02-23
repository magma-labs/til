# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CORS', type: :request do
  describe 'GET /' do
    xit 'receive CORS headers on get requests' do
      get root_path, headers: { 'HTTP_ORIGIN' => '*' }
      expect(response).to have_http_status(:ok)
      expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
      expect(response.headers['Access-Control-Allow-Methods']).to eq('GET, OPTIONS')
      expect(response.headers).to have_key('Access-Control-Max-Age')
    end
  end
end
