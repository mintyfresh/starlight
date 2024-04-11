# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'bootsnap', require: false
gem 'ed25519'
gem 'has_unique_attribute'
gem 'oauth2'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'
gem 'sprockets-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'view_component'

group :development do
  gem 'annotate'
  gem 'rack-mini-profiler'
  gem 'web-console'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri windows]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'rspec-rails'
end
