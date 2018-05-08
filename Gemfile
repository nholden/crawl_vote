source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby `cat .ruby-version`.chomp

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'webpacker'
gem 'turbolinks', '~> 5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'haml'
gem 'decent_exposure', '3.0.0'
gem 'excon'
gem 'sidekiq'
gem 'pusher'
gem 'active_model_serializers', '~> 0.10.0'

group :development, :test do
  gem 'rspec-rails', '~> 3.7'
  gem 'pry'
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-given'
  gem 'webmock'
  gem 'vcr'
  gem 'pusher-fake'
end
