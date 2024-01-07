if ENV["RAILS_LOG_TO_STDOUT"].present? && !defined?(Rails::Console)
  Rails.application.config.semantic_logger.add_appender(
    io: STDOUT,
    level: Rails.application.config.log_level,
    formatter: SemanticLogger::Formatters::Logfmt.new
  )


  unless Sidekiq.server?
    SemanticLogger.on_log do |log|
      span_id = OpenTelemetry::Trace.current_span.context.hex_span_id
      trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id
      if defined? OpenTelemetry::Trace.current_span.name
        operation = OpenTelemetry::Trace.current_span.name
      else
        operation = 'undefined'
      end

      log.named_tags.merge!(trace_id:, span_id:, operation:)
    end
  end
end
