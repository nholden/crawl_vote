source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby `cat .ruby-version`.chomp

gem 'rails', '~> 8.1.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 8.0'
gem 'shakapacker', '10.3.2'
gem 'turbolinks', '~> 5'
gem 'bootsnap', '>= 1.18.0', require: false
gem 'haml'
gem 'decent_exposure', '~> 3.0.4'
gem 'excon'
gem 'sidekiq'
gem 'pusher'
gem 'rollbar'
gem 'graphql'

group :development, :test do
  gem 'rspec-rails', '~> 8.0'
  gem 'pry'
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'dotenv-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 4.2.0'
  gem 'listen', '~> 3.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'graphiql-rails'
end

group :test do
  gem 'rspec-given'
  gem 'webmock'
  gem 'vcr'
  gem 'pusher-fake'
end
