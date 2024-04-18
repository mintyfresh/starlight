# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                          :bigint           not null, primary key
#  type                        :string
#  created_by_id               :bigint           not null
#  discord_guild_id            :bigint           not null
#  name                        :string           not null
#  slug                        :string           not null
#  location                    :string
#  description                 :string
#  time_zone                   :string
#  starts_at_date              :date
#  starts_at_time              :time
#  ends_at_date                :date
#  ends_at_time                :time
#  registration_starts_at_date :date
#  registration_starts_at_time :time
#  registration_ends_at_date   :date
#  registration_ends_at_time   :time
#  registrations_count         :integer          default(0), not null
#  registrations_limit         :integer
#  published_at                :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_events_on_created_by_id  (created_by_id)
#  index_events_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
class ConstructedEvent < Event
  has_configurable_feature :decklist, reject_if: lambda { |attributes|
    attributes['visibility'].blank? && attributes['format'].blank? && attributes['decklist_required'] == '0'
  }

  validates :decklist_config, associated: true

  # Determines if decklists can be submitted for this event.
  #
  # @return [Boolean]
  # @override Event#decklist_permitted?
  def decklist_permitted?
    true
  end

  # Determines if a decklist is required to register for this event.
  #
  # @return [Boolean]
  # @override Event#decklist_required?
  def decklist_required?
    decklist_config&.decklist_required? || false
  end
end
