if ENV["RAILS_ENV"] == "production"
  worker_processes 2
  timeout 30
end
