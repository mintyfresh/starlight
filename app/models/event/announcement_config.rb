# frozen_string_literal: true

# == Schema Information
#
# Table name: event_announcement_configs
#
#  id                 :bigint           not null, primary key
#  event_id           :bigint           not null
#  discord_channel_id :bigint           not null
#  discord_message_id :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_event_announcement_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class Event
  class AnnouncementConfig < ApplicationRecord
    belongs_to :event, inverse_of: :announcement_config

    validates :discord_channel_id, presence: true

    validate on: :update, if: :discord_channel_id_changed? do
      # cannot change the channel once a message has been posted
      # user should delete the config (and thus the message) and create a new one
      discord_message_id.blank? or errors.add(:discord_channel_id, :cannot_be_changed)
    end

    publishes_messages_on :create, :update, :destroy
  end
end
