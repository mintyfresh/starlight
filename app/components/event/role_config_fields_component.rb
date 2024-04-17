# frozen_string_literal: true

class Event
  class RoleConfigFieldsComponent < ApplicationComponent
    CLEANUP_DELAY_OPTIONS = {
      '1 month after the event'   => 1.month.iso8601,
      '1 week after the event'    => 7.days.iso8601,
      '1 day after the event'     => 1.day.iso8601,
      'As soon as the event ends' => 0.seconds.iso8601
    }.freeze

    # @param form [Bootstrap::FormBuilder]
    def initialize(form:)
      @form = form
    end

    # @return [Event::RoleConfig]
    def role_config
      @form.object.role_config || Event::RoleConfig.new
    end
  end
end
