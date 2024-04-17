# frozen_string_literal: true

class Event
  class RoleConfigFieldsComponent < ApplicationComponent
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
