# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
                                                                 :provider => 'google_oauth2',
                                                                 info: { email: 'til@magmalabs.io' }
                                                             })
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods
end
