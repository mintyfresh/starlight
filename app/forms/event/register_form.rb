# frozen_string_literal: true

class Event
  class RegisterForm < ApplicationForm
    # @!attribute [r] event
    #   @return [Event]
    alias event record

    # @return [User]
    attr_accessor :player

    # @!attribute [rw] decklist_attributes
    #   @return [Hash, nil]
    attribute :decklist_attributes

    validates :player, presence: true

    validate :event_is_open_for_registration

    # @return [Registration, nil]
    def save
      return if invalid?

      Event.transaction do
        registration = event.register(player, assigned_attributes)

        # validate that the decklist is present and legal
        validate_decklist_for_registration(registration)

        registration
      end
    rescue ActiveRecord::RecordInvalid => error
      # raised if the decklist data is invalid
      import_errors_from(error.record.errors)

      nil
    end

  private

    # @return [void]
    def event_is_open_for_registration
      event.open_for_registration? or
        errors.add(:base, :not_open_for_registration, name: event.name)
    end

    # @param registration [Registration]
    # @return [void]
    def validate_decklist_for_registration(registration)
      # ensure a decklist is present if required
      if event.decklist_required?
        registration.decklist.present? or
          errors.add(:base, :decklist_required)
      end

      # TODO: Validate that the decklist is legal in the format

      raise ActiveRecord::Rollback if errors.any?
    end
  end
end
