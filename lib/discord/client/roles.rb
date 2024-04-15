# frozen_string_literal: true

module Discord
  class Client
    module Roles
      # @param guild_id [Integer]
      # @return [Array<Discord::Role>]
      # @see https://discord.com/developers/docs/resources/guild#get-guild-roles
      def guild_roles(guild_id)
        @client.get("guilds/#{guild_id}/roles").body.map do |role|
          Discord::Role.new(role)
        end
      end

      # @param guild_id [Integer]
      # @param role [Discord::Role, Hash]
      # @return [Discord::Role]
      # @see https://discord.com/developers/docs/resources/guild#create-guild-role
      def create_guild_role(guild_id, role)
        Discord::Role.new(@client.post("guilds/#{guild_id}/roles", role.to_h).body)
      end

      # @param guild_id [Integer]
      # @param role_id [Integer]
      # @param role [Discord::Role, Hash]
      # @return [Discord::Role]
      # @see https://discord.com/developers/docs/resources/guild#modify-guild-role
      def update_guild_role(guild_id, role_id, role)
        Discord::Role.new(@client.patch("guilds/#{guild_id}/roles/#{role_id}", role.to_h).body)
      end

      # @param guild_id [Integer]
      # @param role_id [Integer]
      # @return [true]
      # @see https://discord.com/developers/docs/resources/guild#delete-guild-role
      def delete_guild_role(guild_id, role_id)
        @client.delete("guilds/#{guild_id}/roles/#{role_id}").body && true
      end

      # @param guild_id [Integer]
      # @param user_id [Integer]
      # @param role_id [Integer]
      # @return [void]
      def add_guild_member_role(guild_id, user_id:, role_id:)
        @client.put("guilds/#{guild_id}/members/#{user_id}/roles/#{role_id}").body
      end

      # @param guild_id [Integer]
      # @param user_id [Integer]
      # @param role_id [Integer]
      # @return [void]
      def remove_guild_member_role(guild_id, user_id:, role_id:)
        @client.delete("guilds/#{guild_id}/members/#{user_id}/roles/#{role_id}").body
      end
    end
  end
end
