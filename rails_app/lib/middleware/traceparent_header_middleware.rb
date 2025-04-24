module Middleware
  class TraceparentHeaderMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      current_span_context = OpenTelemetry::Trace.current_span.context

      if current_span_context.valid?
        trace_id = current_span_context.hex_trace_id
        span_id = current_span_context.hex_span_id
        sampled = current_span_context.trace_flags.sampled? ? "01" : "00"
        traceparent = "00-#{trace_id}-#{span_id}-#{sampled}"

        headers["traceparent"] = traceparent
      end

      [status, headers, response]
    end
  end
end
