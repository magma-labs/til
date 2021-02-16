# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

host_name = URI(ENV.fetch('HOST_NAME', 'http://localhost:3000'))
ApplicationController.renderer.defaults.merge!(
  http_host: host_name.host,
  https: host_name.is_a?(URI::HTTPS)
)
