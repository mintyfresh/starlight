# frozen_string_literal: true

# == Schema Information
#
# Table name: event_role_configs
#
#  id              :bigint           not null, primary key
#  event_id        :bigint           not null
#  discord_role_id :bigint
#  name            :string           not null
#  permissions     :string           default("0"), not null
#  colour          :integer          default(0), not null
#  hoist           :boolean          default(FALSE), not null
#  mentionable     :boolean          default(FALSE), not null
#  cleanup_delay   :interval
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_event_role_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class Event
  class RoleConfig < ApplicationRecord
    # @type [Integer]
    # @see https://discord.com/developers/docs/resources/guild#create-guild-role-json-params
    NAME_MAX_LENGTH = 100

    # @type [Hash{Symbol => Symbol}]
    # @see https://discord.com/developers/docs/resources/guild#create-guild-role-json-params
    DISCORD_ROLE_ATTRIBUTES = {
      name:        :name,
      permissions: :permissions,
      color:       :colour,
      hoist:       :hoist,
      mentionable: :mentionable
    }.freeze

    belongs_to :event, inverse_of: :role_config

    validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
    validates :permissions, presence: true
    validates :colour, numericality: { in: 0x000000..0xFFFFFF }
    validates :hoist, inclusion: { in: [true, false] }
    validates :mentionable, inclusion: { in: [true, false] }

    publishes_messages_on :create, :update, :destroy

    # @!method self.ready_for_cleanup
    #   Returns all role configurations that are ready for cleanup.
    #   @return [Class<Event::RoleConfig>]
    scope :ready_for_cleanup, lambda {
      joins(:event)
        .where.not(discord_role_id: nil)
        .where.not(cleanup_delay: nil)
        .where((Event.arel_table[:ends_at] + arel_table[:cleanup_delay]).lt(bind_param('now', Time.current)))
    }

    # @param event [Event]
    # @return [Boolean]
    def self.active_for_event?(event)
      event.role_config&.discord_role_id.present?
    end

    # @param value [Integer, String, nil]
    # @return [void]
    def colour=(value)
      if value.is_a?(String) && value.starts_with?('#')
        super(value.delete_prefix('#').to_i(16))
      else
        super
      end
    end

    # Formats the colour as a hexadecimal string, prefixed with a hash.
    # Suitable for use with HTML color input elements.
    #
    # @return [String, nil]
    def colour_as_hex
      colour && ('#%06X' % colour)
    end

    # Determines if the role configuration is ready for cleanup.
    #
    # @return [Boolean]
    def ready_for_cleanup?
      discord_role_id.present? &&
        cleanup_delay.present? &&
        event.ends_at.present? &&
        (event.ends_at + cleanup_delay).past?
    end

    # @return [Hash{Symbol => Object}]
    def discord_role_attributes
      DISCORD_ROLE_ATTRIBUTES.transform_values { |attribute| send(attribute) }
    end
  end
end
