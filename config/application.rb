# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module HrTil
  class Application < Rails::Application
    config.active_record.schema_format = :sql
    config.autoload_paths << Rails.root.join('lib')
    config.time_zone = 'Eastern Time (US & Canada)'
  end
end
