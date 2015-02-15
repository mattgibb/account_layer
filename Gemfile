source 'https://rubygems.org'
ruby '2.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem "omniauth-oauth2"

# Wells Fargo Quicken file format parser
gem 'quicken_parser'

# frontend app can access api
gem 'rack-cors', require: 'rack/cors'

# JWT auth
gem 'jwt'

# read First Associates shizzle
gem 'simple_xlsx_reader'

group :development do
  gem 'guard-rspec', require: false
  gem 'terminal-notifier-guard', '~> 1.6.1'
  gem "spring-commands-rspec"
end

group :development, :test do
  gem 'rspec-rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # factories instead of fixtures
  gem 'factory_girl_rails'
end
