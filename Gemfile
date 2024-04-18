# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'action_policy'
gem 'bootsnap', require: false
gem 'bootstrap'
gem 'colorize'
gem 'dry-struct'
gem 'dry-types'
gem 'ed25519'
gem 'has_unique_attribute'
gem 'importmap-rails', '~> 2.0'
gem 'money-rails'
gem 'moonfire', github: 'mintyfresh/moonfire'
gem 'oauth2'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'
gem 'request_store'
gem 'sprockets-rails'
gem 'tod'
gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'view_component'
gem 'where_any'

group :development do
  gem 'annotate'
  gem 'mini_racer'
  gem 'rack-mini-profiler'
  gem 'web-console'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri windows]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'rspec-rails'
  gem 'webmock'
end
