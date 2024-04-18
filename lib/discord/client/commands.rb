# frozen_string_literal: true

module Discord
  class Client
    module Commands
      # @param application_id [Integer]
      # @return [Array<Discord::ApplicationCommand>]
      # @see https://discord.com/developers/docs/interactions/application-commands#get-global-application-commands
      def global_commands(application_id)
        get Discord::ApplicationCommand, "applications/#{application_id}/commands"
      end

      # @param application_id [Integer]
      # @param command_id [Integer]
      # @return [Discord::ApplicationCommand]
      # @see https://discord.com/developers/docs/interactions/application-commands#get-global-application-command
      def global_command(application_id, command_id)
        get Discord::ApplicationCommand, "applications/#{application_id}/commands/#{command_id}"
      end

      # @param application_id [Integer]
      # @param command [Hash, Discord::ApplicationCommand]
      # @return [Discord::ApplicationCommand]
      # @see https://discord.com/developers/docs/interactions/application-commands#create-global-application-command
      def create_global_command(application_id, command)
        post Discord::ApplicationCommand, "applications/#{application_id}/commands", command
      end

      # @param application_id [Integer]
      # @param command_id [Integer]
      # @return [true]
      # @see https://discord.com/developers/docs/interactions/application-commands#delete-global-application-command
      def delete_global_command(application_id, command_id)
        delete "applications/#{application_id}/commands/#{command_id}"
      end
    end
  end
end
