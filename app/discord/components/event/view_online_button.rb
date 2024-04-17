# frozen_string_literal: true

module Components
  module Event
    class ViewOnlineButton < Button
      # @param event [Event]
      def initialize(event)
        super()

        @event = event
      end

      style :link
      label 'View Online'
      url { event_url(@event) }
    end
  end
end
