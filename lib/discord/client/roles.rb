# frozen_string_literal: true

module Discord
  class Client
    module Roles
      # @param guild_id [Integer]
      # @return [Array<Discord::Role>]
      # @see https://discord.com/developers/docs/resources/guild#get-guild-roles
      def guild_roles(guild_id)
        get Discord::Role, "guilds/#{guild_id}/roles"
      end

      # @param guild_id [Integer]
      # @param role [Discord::Role, Hash]
      # @return [Discord::Role]
      # @see https://discord.com/developers/docs/resources/guild#create-guild-role
      def create_guild_role(guild_id, role)
        post Discord::Role, "guilds/#{guild_id}/roles", role
      end

      # @param guild_id [Integer]
      # @param role_id [Integer]
      # @param role [Discord::Role, Hash]
      # @return [Discord::Role]
      # @see https://discord.com/developers/docs/resources/guild#modify-guild-role
      def update_guild_role(guild_id, role_id, role)
        patch Discord::Role, "guilds/#{guild_id}/roles/#{role_id}", role
      end

      # @param guild_id [Integer]
      # @param role_id [Integer]
      # @return [true]
      # @see https://discord.com/developers/docs/resources/guild#delete-guild-role
      def delete_guild_role(guild_id, role_id)
        delete "guilds/#{guild_id}/roles/#{role_id}"
      end

      # @param guild_id [Integer]
      # @param user_id [Integer]
      # @param role_id [Integer]
      # @return [true]
      def add_guild_member_role(guild_id, user_id:, role_id:)
        put "guilds/#{guild_id}/members/#{user_id}/roles/#{role_id}"
      end

      # @param guild_id [Integer]
      # @param user_id [Integer]
      # @param role_id [Integer]
      # @return [true]
      def remove_guild_member_role(guild_id, user_id:, role_id:)
        delete "guilds/#{guild_id}/members/#{user_id}/roles/#{role_id}"
      end
    end
  end
end
