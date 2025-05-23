#!/usr/bin/env -S falcon host
# frozen_string_literal: true

require "falcon/environment/rack"
require_relative "limited"

hostname = File.basename(__dir__)
port = ENV["PORT"] || 80


service hostname do
  count 2
  preload "preload.rb"
  include Falcon::Environment::Rack

  endpoint_options do
    super().merge(wrapper: Limited::Wrapper.new)
  end

  endpoint do
    ::Async::HTTP::Endpoint.parse("http://0.0.0.0:#{port}").with(**endpoint_options)
  end
end
