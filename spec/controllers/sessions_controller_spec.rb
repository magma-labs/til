# frozen_string_literal: true

require 'rails_helper'
describe SessionsController do
  describe '#create' do
    before do
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
        {
            provider: 'google_oauth2',
            info: { email: 'jake@magmalabs.io' }
        }
      )
    end

    context 'with oauth' do
      it 'signs in existing developer by email' do
        developer = FactoryBot.create :developer, email: 'jake@magmalabs.io'

        expect do
          post :create
          expect(response).to redirect_to root_path
        end.to change(session, :count).by(2)

        expect(session[:developer_email]).to eq developer.email
      end

      it 'does successfully create a session' do
        expect(session[:developer_id]).to be_nil
        post :create, params: { provider: :google_oauth2 }
        expect(session[:developer_email]).not_to be_nil
      end
    end

    context 'when signs up' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          {
              provider: 'google_oauth2',
              info: {
                  email: 'newdev@magmalabs.io',
                  name: 'John Smith'
              }
          }
        )
      end

      it 'a new developer by email' do
        expect do
          post :create
          expect(response).to redirect_to root_path
        end.to change(Developer, :count).by(1)
        developer = Developer.where(email: 'newdev@magmalabs.io')
        expect(session[:developer_email]).to eq developer.first.email
      end
    end
  end

  describe '#destroy' do
    before do
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
        {
            provider: 'google_oauth2',
            info: { email: 'jake@magmalabs.io' }
        }
      )
      post :create, params: { provider: :google_oauth2 }
    end

    it 'does clear the session' do
      expect(session[:developer_email]).not_to be_nil
      delete :destroy
      expect(session[:developer_email]).to be_nil
    end

    it 'does redirect to the home page' do
      delete :destroy
      expect(response).to redirect_to root_url
    end
  end
end
