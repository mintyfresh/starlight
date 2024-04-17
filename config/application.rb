# frozen_string_literal: true

require_relative 'boot'

require 'rails'

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Starlight
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.helper false
      g.assets false
    end

    # Apply bootstrap error styling to form fields.
    config.action_view.field_error_proc = proc { |html_tag, _|
      fragment = Nokogiri::HTML.fragment(html_tag)
      element  = fragment.child

      # Don't apply the error styling to labels.
      next html_tag if element.nil? || element.name == 'label'

      # Append the `is-invalid` CSS class to the input element.
      element[:class] = [*element[:class], 'is-invalid'].join(' ')
      # Append the `aria-describedby` attribute to the input element to indicate the error message.
      element['aria-describedby'] = [element['aria-describedby'], "#{element[:id]}_errors"].compact.join(' ')

      element.to_html.html_safe # rubocop:disable Rails/OutputSafety
    }
  end
end
