# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

OmniAuth.configure do |config|
  config.test_mode = true
  config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
    {
        provider: 'google_oauth2',
        info: { email: 'til@magmalabs.io' }
    }
  )
  config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    {
        provider: 'google_oauth2',
        uid: '12345678910',
        info: {
            email: 'flow@magmalabs.io',
            username: 'flow-velazquez'
        }, credentials: {
            token: 'abcdefg12345',
            refresh_token: '12345abcdefg',
            expires_at: DateTime.now
        }
    }
  )
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods
end
