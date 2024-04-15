# frozen_string_literal: true

module Discord
  class Client
    module Roles
      # @param guild_id [Integer]
      # @param attributes [Hash]
      # @return [Hash]
      def create_guild_role(guild_id, permissions: '0', **)
        @client.post("guilds/#{guild_id}/roles", { permissions:, ** }).body
      end

      # @param guild_id [Integer]
      # @param role_id [Integer]
      # @param attributes [Hash]
      # @return [Hash]
      def update_guild_role(guild_id, role_id:, **attributes)
        @client.patch("guilds/#{guild_id}/roles/#{role_id}", attributes).body
      end

      # @param guild_id [Integer]
      # @param role_id [Integer]
      # @return [Hash]
      def delete_guild_role(guild_id, role_id:)
        @client.delete("guilds/#{guild_id}/roles/#{role_id}").body
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
