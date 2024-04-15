# frozen_string_literal: true

class CreateEventAnnouncementConfigs < ActiveRecord::Migration[7.1]
  def change
    create_table :event_announcement_configs do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: { unique: true }
      t.bigint     :discord_channel_id, null: false
      t.bigint     :discord_message_id
      t.timestamps
    end
  end
end
