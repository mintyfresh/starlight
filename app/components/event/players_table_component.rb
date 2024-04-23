# frozen_string_literal: true

class Event
  class PlayersTableComponent < ApplicationComponent
    # @param event [Event]
    # @param current_user [User]
    def initialize(event:, current_user:)
      super()

      @event         = event
      @current_user  = current_user
      @registrations = event.registrations.includes(:player, :decklist)
    end

    # @param registration [Registration]
    # @return [String, nil]
    def link_to_decklist(registration)
      return unless decklist_visible?(registration)

      if registration.decklist.present?
        link_to(registration.decklist.deck_name || 'Decklist', registration.decklist.ponyhead_url)
      else
        tag.span('No decklist', class: 'text-muted')
      end
    end

    # @param registration [Registration]
    # @return [Boolean]
    def decklist_visible?(registration)
      return false if @event.decklist_config.nil?
      return false if registration.decklist.nil?

      # players can always see their own decklist
      return true if registration.player == @current_user

      case @event.decklist_config.visibility
      when 'judges_only' then @current_user == @event.created_by
      when 'other_players' then @event.registered?(@current_user)
      when 'everyone' then true
      end
    end
  end
end
