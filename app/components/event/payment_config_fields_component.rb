# frozen_string_literal: true

class Event
  class PaymentConfigFieldsComponent < ApplicationComponent
    # @param form [Bootstrap::FormBuilder]
    def initialize(form:)
      @form = form
    end

    # @return [Event::PaymentConfig]
    def payment_config
      @form.object.payment_config || Event::PaymentConfig.new
    end

    # @return [Array]
    def currency_options
      Money::Currency.all.map { |currency| ["#{currency.name} (#{currency.iso_code})", currency.iso_code] }
    end
  end
end
