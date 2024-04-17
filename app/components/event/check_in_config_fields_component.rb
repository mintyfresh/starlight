# frozen_string_literal: true

class Event
  class CheckInConfigFieldsComponent < ApplicationComponent
    # @param form [Bootstrap::FormBuilder]
    def initialize(form:)
      @form = form
    end

    # @return [Event::CheckInConfig]
    def check_in_config
      @form.object.check_in_config || Event::CheckInConfig.new
    end
  end
end
