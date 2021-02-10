# frozen_string_literal:true

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer
  provider :google_oauth2,
           ENV['google_client_id'],
           ENV['google_client_secret'],
           { scope: 'email', hd: ENV['permitted_domains'] }
end

OmniAuth.config.allowed_request_methods = %i[post get]
