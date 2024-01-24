Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "demo/ping"
  get "demo/database_bulk_read"
  get "demo/database_sequential_read"

  get "demo/database_bulk_insert"
  get "demo/database_sequential_insert"

  get "demo/database_delete_all"

  get "demo/remote_http_call"

  get "demo/increment_own_metric"

  get "demo/perform_async_job"

  get "demo/response_500"

  # Defines the root path route ("/")
  root "demo#ping"
end
