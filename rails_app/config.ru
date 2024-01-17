# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

use StatsDRackInstrument if defined? StatsDRackInstrument

run Rails.application
Rails.application.load_server
