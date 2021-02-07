# frozen_string_literal:true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['google_client_id'], ENV['google_client_secret']
end

OmniAuth.config.full_host = "#{ENV['protocol']}#{ENV['host']}"
