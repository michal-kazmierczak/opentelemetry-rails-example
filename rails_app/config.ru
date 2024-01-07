# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

if ENV["STATSD_ADDR"].present?
  require "statsd_rack_instrument"
  use StatsDRackInstrument
end

run Rails.application
Rails.application.load_server
