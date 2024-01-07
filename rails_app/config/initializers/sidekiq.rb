Sidekiq.configure_client do |config|
end

# ensure context information in the logs
# inspired by https://github.com/reidmorrison/semantic_logger/issues/51#issuecomment-538406797
require "sidekiq/job_logger"
class SidekiqTaggedJobLogger < Sidekiq::JobLogger
  def call(item, queue)
    @logger.tagged(Sidekiq::Context.current) do
      super(item, queue)
    end
  end
end

module SidekiqMiddleware
  class AutoTaggingTracer
    def call(worker, _job, _queue)
      span_id = OpenTelemetry::Trace.current_span.context.hex_span_id
      trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id
      if defined? OpenTelemetry::Trace.current_span.name
        operation = OpenTelemetry::Trace.current_span.name
      else
        operation = 'undefined'
      end
      Sidekiq::Context.add(:span_id, span_id)
      Sidekiq::Context.add(:trace_id, trace_id)
      Sidekiq::Context.add(:operation, operation)

      yield
    end
  end
end

Sidekiq.configure_server do |config|
  config.client_middleware do |chain| # server can also act as a client
    chain.add SidekiqMiddleware::AutoTaggingTracer
  end
  config.server_middleware do |chain|
    chain.add SidekiqMiddleware::AutoTaggingTracer
  end

  config.options[:job_logger] = SidekiqTaggedJobLogger
end

