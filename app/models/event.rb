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
class Event < ApplicationRecord
  include Sluggable

  NAME_MAX_LENGTH = 40
  LOCATION_MAX_LENGTH = 250
  DESCRIPTION_MAX_LENGTH = 5000

  # virtual columns calculated from their corresponding date and time columns
  # we reimplement these in the model to have access to unpermitted changes in these attributes
  self.ignored_columns += %w[starts_at ends_at registration_starts_at registration_ends_at]

  strips_whitespace_from :name, :location, :description

  attribute :starts_at_time, :time_only
  attribute :ends_at_time, :time_only
  attribute :registration_starts_at_time, :time_only
  attribute :registration_ends_at_time, :time_only

  # reconstructs the timestamps from their corresponding date and time columns, as well as the time zone
  timestamps_from_parts :starts_at, :ends_at, :registration_starts_at, :registration_ends_at, time_zone: :time_zone

  belongs_to :created_by, class_name: 'User', inverse_of: :created_events

  has_many :registrations, dependent: :destroy, inverse_of: :event
  has_many :registered_players, through: :registrations, source: :player

  has_one :announcement_config, class_name: 'Event::AnnouncementConfig', dependent: :destroy, inverse_of: :event
  accepts_nested_attributes_for :announcement_config, allow_destroy: true, update_only: true, reject_if: :all_blank

  has_one :role_config, class_name: 'Event::RoleConfig', dependent: :destroy, inverse_of: :event
  accepts_nested_attributes_for :role_config, allow_destroy: true, update_only: true, reject_if: lambda { |attributes|
    attributes['name'].blank?
  }

  has_unique_attribute :name, index: 'index_events_on_slug'

  validates :discord_guild_id, presence: true
  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :location, length: { maximum: LOCATION_MAX_LENGTH }
  validates :description, length: { maximum: DESCRIPTION_MAX_LENGTH }
  validates :registrations_limit, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :time_zone, time_zone: true

  validates :announcement_config, associated: true
  validates :role_config, associated: true

  # the event must start before it ends
  validate if: -> { starts_at.present? && ends_at.present? } do
    starts_at < ends_at or errors.add(
      :starts_at, :before_attribute,
      attribute: human_attribute_name(:ends_at),
      value:     I18n.l(ends_at, format: :datetime_local)
    )
  end

  # registration must start before it ends
  validate if: -> { registration_starts_at.present? && registration_ends_at.present? } do
    registration_starts_at < registration_ends_at or errors.add(
      :registration_starts_at, :before_attribute,
      attribute: human_attribute_name(:registration_ends_at),
      value:     I18n.l(registration_ends_at, format: :datetime_local)
    )
  end

  # registration must start before the event starts
  validate if: -> { starts_at.present? && registration_starts_at.present? } do
    registration_starts_at < starts_at or errors.add(
      :registration_starts_at, :before_attribute,
      attribute: human_attribute_name(:starts_at),
      value:     I18n.l(starts_at, format: :datetime_local)
    )
  end

  with_options if: :published? do
    validates :time_zone, presence: true
    validates :starts_at, presence: true
    validates :ends_at, presence: true
  end

  slugifies :name

  publishes_messages_on :create, :update, :destroy

  publishes_message :publish, if: :published_by_last_save?

  # @!method self.published
  #   @return [Class<Event>]
  scope :published, -> { where.not(published_at: nil) }

  # Checks if the event is a draft.
  #
  # @return [Boolean]
  def draft?
    published_at.nil?
  end

  # Checks if the event is published.
  #
  # @return [Boolean]
  def published?
    published_at.present?
  end

  # Publishes the event if it is not already published.
  # Has no effect if the record is already published.
  #
  # @return [Boolean]
  def publish
    published? or update(published_at: Time.current)
  end

  # Publishes the event if it is not already published.
  # Has no effect if the record is already published.
  #
  # @return [true]
  # @raise [ActiveRecord::RecordInvalid] if the record cannot be published
  def publish!
    published? or update!(published_at: Time.current)
  end

  # Determines if the record was published by the last save operation.
  #
  # @return [Boolean]
  def published_by_last_save?
    published? && published_at_before_last_save.nil?
  end

  # Determines if the event is open for registration.
  #
  # To be open for registration, the event must:
  # - be published
  # - be past its registration start date (if set)
  # - not be past its registration end date (if set)
  # - not be past its end date
  #
  # @return [Boolean]
  def open_for_registration?
    return false if draft?
    return false if registration_starts_at&.future?
    return false if registration_ends_at&.past?

    ends_at.future?
  end

  # Checks if a player is registered for the event.
  # Also returns false if the player is nil.
  #
  # @param player [User, nil]
  # @return [Boolean]
  def registered?(player)
    player.present? && registrations.exists?(player:)
  end

  # Registers a player for the event.
  # Optionally, the player can be registered by another user.
  # Has no effect if the player is already registered.
  #
  # If the event is not open for registration, an error is added to the base.
  #
  # @param player [User]
  # @param created_by [User]
  # @return [Registration, nil]
  def register(player, created_by: player)
    unless open_for_registration?
      errors.add(:base, :not_open_for_registration, name:)
      return
    end

    registrations.create_with(created_by:).create_or_find_by!(player:)
  end
end
