class ApplicationJob < ActiveJob::Base
  include SemanticLoggerTraceContext
end
