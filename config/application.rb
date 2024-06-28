# frozen_string_literal: true

require_relative 'boot'

%w(
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
).each do |railtie|
  begin # rubocop:disable Style/RedundantBegin
    require railtie
  rescue LoadError
  end
end

Bundler.require(*Rails.groups)

module HrTil
  class Application < Rails::Application
    config.active_record.schema_format = :sql
    config.autoload_paths << Rails.root.join('lib')
    config.time_zone = 'Eastern Time (US & Canada)'
  end
end
