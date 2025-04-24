# frozen_string_literal: true

module Middleware
  class TelemetrySemanticLoggingMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      current_span_context = OpenTelemetry::Trace.current_span.context

      if current_span_context.valid?
        span_id = OpenTelemetry::Trace.current_span.context.hex_span_id
        trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id

        SemanticLogger.named_tagged(trace_id:, span_id:) do
          @app.call(env)
        end
      else
        @app.call(env)
      end
    end
  end
end
