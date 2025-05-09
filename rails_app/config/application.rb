require_relative "boot"

require "rails/all"

require_relative "../lib/middleware/telemetry_semantic_logging_middleware"
require_relative "../lib/middleware/traceparent_header_middleware"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "statsd_rack_instrument" if ENV["STATSD_ADDR"].present?

module OpentelemetryRailsExample
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.log_tags = [:request_id]
    # Send logs to STDOUT (useful for Docker/Kubernetes)
    config.rails_semantic_logger.add_file_appender = false

    config.middleware.use Middleware::TraceparentHeaderMiddleware
    config.middleware.insert_before Rails::Rack::Logger, Middleware::TelemetrySemanticLoggingMiddleware
  end
end
