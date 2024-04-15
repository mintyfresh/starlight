# frozen_string_literal: true

module Discord
  class Client
    module Commands
      # @param application_id [Integer]
      # @return [Array<Discord::ApplicationCommand>]
      # @see https://discord.com/developers/docs/interactions/application-commands#get-global-application-commands
      def global_commands(application_id)
        @client.get("applications/#{application_id}/commands").body.map do |command|
          Discord::ApplicationCommand.new(command)
        end
      end

      # @param application_id [Integer]
      # @param command_id [Integer]
      # @return [Discord::ApplicationCommand]
      # @see https://discord.com/developers/docs/interactions/application-commands#get-global-application-command
      def global_command(application_id, command_id)
        Discord::ApplicationCommand.new(@client.get("applications/#{application_id}/commands/#{command_id}").body)
      end

      # @param application_id [Integer]
      # @param command [Hash, Discord::ApplicationCommand]
      # @return [Discord::ApplicationCommand]
      # @see https://discord.com/developers/docs/interactions/application-commands#create-global-application-command
      def create_global_command(application_id, command)
        Discord::ApplicationCommand.new(@client.post("applications/#{application_id}/commands", command.to_h).body)
      end

      # @param application_id [Integer]
      # @param command_id [Integer]
      # @return [true]
      # @see https://discord.com/developers/docs/interactions/application-commands#delete-global-application-command
      def delete_global_command(application_id, command_id)
        @client.delete("applications/#{application_id}/commands/#{command_id}") && true
      end
    end
  end
end
