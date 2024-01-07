if ENV["OTEL_EXPORTER_OTLP_ENDPOINT"] && !defined?(::Rails::Console)
  require "opentelemetry/sdk"
  require "opentelemetry/exporter/otlp"

  OpenTelemetry::SDK.configure do |c|
    c.service_name = ENV['SERVICE_NAME']
    c.use_all
  end
end
