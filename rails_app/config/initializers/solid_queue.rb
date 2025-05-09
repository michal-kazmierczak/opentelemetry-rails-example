SolidQueue.on_worker_start do
  # Re-open appenders after forking the process
  SemanticLogger.reopen
end
