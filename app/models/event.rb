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
  include ConfigurableFeatures
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

  has_configurable_feature :announcement
  has_configurable_feature :check_in
  has_configurable_feature :payment
  has_configurable_feature :role, reject_if: -> (attributes) { attributes['name'].blank? }

  has_unique_attribute :name, index: 'index_events_on_slug'

  validates :discord_guild_id, presence: true
  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :location, length: { maximum: LOCATION_MAX_LENGTH }
  validates :description, length: { maximum: DESCRIPTION_MAX_LENGTH }
  validates :registrations_limit, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :time_zone, time_zone: true

  # the event must start before it ends
  validates :starts_at, before_attribute: :ends_at

  # registration must start before it ends
  validates :registration_starts_at, before_attribute: :registration_ends_at

  # registration must start before the event starts
  validates :registration_starts_at, before_attribute: :starts_at

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

  # Determines if decklists can be submitted for this event.
  #
  # @return [Boolean]
  def decklist_permitted?
    false
  end

  # Determines if a decklist is required to register for this event.
  #
  # @return [Boolean]
  def decklist_required?
    false
  end

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

  # Determines if the event is open for check-in.
  #
  # @return [Boolean]
  def open_for_check_in?
    (published? && check_in_config&.open?) || false
  end

  # Checks if a player is registered for the event.
  # Always returns false if the player is nil.
  #
  # @param player [User, nil]
  # @return [Boolean]
  def registered?(player)
    player.present? && registrations.exists?(player:)
  end

  # Checks if a player is checked-in for the event.
  # Always returns false if the player is nil.
  #
  # @param player [User, nil]
  # @return [Boolean]
  def checked_in?(player)
    registrations.checked_in.exists?(player:)
  end

  # Registers a player for the event.
  # Optionally, the player can be registered by another user.
  # Has no effect if the player is already registered.
  #
  # @param player [User] the player to register for the event
  # @param attributes [Hash] additional attributes for the registration
  # @param created_by [User] the user registering the player
  # @return [Registration]
  def register(player, attributes = {}, created_by: player)
    registration = registrations.create_with(attributes.merge(created_by:)).find_or_initialize_by(player:)

    registration.assign_attributes(attributes)
    registration.save(content: :register)

    registration
  end

  # Checks in a player for the event.
  # Optionally, the player can be checked in by another user.
  # Has no effect if the player is already checked in.
  #
  # @param player [User] the player to check in
  # @param created_by [User] the user checking in the player
  # @return [Boolean]
  def check_in(player, created_by: player)
    # event must be open for check-in
    unless open_for_check_in?
      errors.add(:base, :not_open_for_check_in, name:)
      return
    end

    # player must be registered to check in
    if (registration = registrations.find_by(player:)).nil?
      errors.add(:base, :not_registered, name:)
      return
    end

    registration.check_in!(created_by:)
  end
end
