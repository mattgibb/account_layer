Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_apps_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
end
