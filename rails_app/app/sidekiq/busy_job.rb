class BusyJob
  include Sidekiq::Job

  def perform(*args)
    sleep 1
  end
end
