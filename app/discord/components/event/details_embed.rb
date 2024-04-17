# frozen_string_literal: true

module Components
  module Event
    class DetailsEmbed < Embed
      # @param event [Event]
      def initialize(event)
        super()

        @event = event
      end

      title { @event.name }
      description { @event.description }

      field 'Location' do
        @event.location
      end

      field 'Starts At' do
        format_timestamp(@event.starts_at)
      end
      field 'Ends At' do
        format_timestamp(@event.ends_at)
      end

      field 'Registration Opens At' do
        format_timestamp(@event.registration_starts_at)
      end
      field 'Registration Closes At' do
        format_timestamp(@event.registration_ends_at)
      end

      footer do
        "Event created by #{@event.created_by.name}."
      end

    private

      # @param time [Time]
      # @return [String]
      def format_timestamp(time)
        <<~TEXT.strip
          <t:#{time.to_i}:f>
          (#{time.strftime('%B %-d, %Y %l:%M %p %Z')})
        TEXT
      end
    end
  end
end
