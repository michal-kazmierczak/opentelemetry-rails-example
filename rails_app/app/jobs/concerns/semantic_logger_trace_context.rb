module SemanticLoggerTraceContext
  extend ActiveSupport::Concern

  included do
    around_perform do |job, block|
      perform_with_semantic_logger(job, &block)
    end
  end

  private

  def perform_with_semantic_logger(job, &block)
    current_span_context = OpenTelemetry::Trace.current_span.context

    if current_span_context.valid?
      span_id = current_span_context.hex_span_id
      trace_id = current_span_context.hex_trace_id
      job_class = job.class.name
      job_id = job.job_id

      # any log produced in this block will be tagged with the telemetry context
      SemanticLogger.named_tagged(job_class:, job_id:, trace_id:, span_id:) do
        Rails.logger.info("ActiveJob Telemetry Correlation")

        block.call
      end
    else
      block.call
    end
  end
end
