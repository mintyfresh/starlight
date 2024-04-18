# frozen_string_literal: true

class Event
  class DecklistConfigFieldsComponent < ApplicationComponent
    # @param form [Bootstrap::FormBuilder]
    def initialize(form:)
      @form = form
    end

    # @return [Event::DecklistConfig]
    def decklist_config
      @form.object.decklist_config || Event::DecklistConfig.new
    end

    # @return [Hash{String => String}]
    def visibility_options
      Event::DecklistConfig::VISIBILITIES.map do |visibility|
        [Event::DecklistConfig.human_visibility_name(visibility), visibility]
      end
    end

    # @return [Hash{String => String}]
    def format_options
      Event::DecklistConfig::FORMATS.map do |format|
        [Event::DecklistConfig.human_format_name(format), format]
      end
    end

    # @return [Hash{String => String}]
    def format_behaviour_options
      Event::DecklistConfig::FORMAT_BEHAVIOURS.map do |behaviour|
        [Event::DecklistConfig.human_format_behaviour_name(behaviour), behaviour]
      end
    end
  end
end
