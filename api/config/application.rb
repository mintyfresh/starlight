# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_view/railtie'
require 'action_cable/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Starlight
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Use FactoryBot and RSpec for testing
    config.generators do |g|
      g.test_framework      :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    # Include indexes in error keys for nested attributes
    config.active_record.index_nested_attribute_errors = true

    # Allow error messages for nested attributes with indices to be translated
    config.active_model.i18n_customize_full_message = true

    # Prepare a configuration object for Argon2 options
    # (these are assigned by the various environment config files)
    config.argon2 = ActiveSupport::OrderedOptions.new
  end
end
