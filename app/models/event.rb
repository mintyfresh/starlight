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
  NAME_MAX_LENGTH = 40
  LOCATION_MAX_LENGTH = 250
  DESCRIPTION_MAX_LENGTH = 5000

  # virtual columns calculated from their corresponding date and time columns
  # we reimplement these in the model to have access to unpermitted changes in these attributes
  self.ignored_columns += %w[starts_at ends_at registration_starts_at registration_ends_at]

  attribute :starts_at_time, :string
  attribute :ends_at_time, :string
  attribute :registration_starts_at_time, :string
  attribute :registration_ends_at_time, :string

  belongs_to :created_by, class_name: 'User', inverse_of: :created_events

  has_unique_attribute :name, index: 'index_events_on_slug'

  validates :discord_guild_id, presence: true
  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :location, length: { maximum: LOCATION_MAX_LENGTH }
  validates :description, length: { maximum: DESCRIPTION_MAX_LENGTH }
  validates :registrations_limit, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  validate if: -> { time_zone.present? } do
    ActiveSupport::TimeZone[time_zone] or errors.add(:time_zone, :invalid)
  end

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

  before_save if: :name_changed? do
    self.slug = name.parameterize
  end

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

  # @return [ActiveSupport::TimeWithZone, nil]
  def starts_at
    timestamp_in_time_zone(starts_at_date, starts_at_time)
  end

  # @param timestamp [ActiveSupport::TimeWithZone, String, nil]
  # @return [void]
  def starts_at=(timestamp)
    self.starts_at_date, self.starts_at_time = extract_date_and_time(timestamp)
  end

  # @return [ActiveSupport::TimeWithZone, nil]
  def ends_at
    timestamp_in_time_zone(ends_at_date, ends_at_time)
  end

  # @param timestamp [ActiveSupport::TimeWithZone, String, nil]
  # @return [void]
  def ends_at=(timestamp)
    self.ends_at_date, self.ends_at_time = extract_date_and_time(timestamp)
  end

  # @return [ActiveSupport::TimeWithZone, nil]
  def registration_starts_at
    timestamp_in_time_zone(registration_starts_at_date, registration_starts_at_time)
  end

  # @param timestamp [ActiveSupport::TimeWithZone, String, nil]
  # @return [void]
  def registration_starts_at=(timestamp)
    self.registration_starts_at_date, self.registration_starts_at_time = extract_date_and_time(timestamp)
  end

  # @return [ActiveSupport::TimeWithZone, nil]
  def registration_ends_at
    timestamp_in_time_zone(registration_ends_at_date, registration_ends_at_time)
  end

  # @param timestamp [ActiveSupport::TimeWithZone, String, nil]
  # @return [void]
  def registration_ends_at=(timestamp)
    self.registration_ends_at_date, self.registration_ends_at_time = extract_date_and_time(timestamp)
  end

  # @return [String]
  def to_param
    slug
  end

protected

  # @param date [Date, nil]
  # @param time [String, nil]
  # @param time_zone [String, nil]
  # @return [ActiveSupport::TimeWithZone, nil]
  def timestamp_in_time_zone(date, time, time_zone: self.time_zone)
    date && time && time_zone && ActiveSupport::TimeZone[time_zone]&.parse("#{date} #{time}")
  end

  # @param timestamp [ActiveSupport::TimeWithZone, String, nil]
  # @return [Array<Date, String>, Array<nil, nil>]
  def extract_date_and_time(timestamp)
    case timestamp
    when ActiveSupport::TimeWithZone, Time
      [timestamp.to_date, timestamp.strftime('%H:%M:%S')]
    when String
      timestamp.split(/ |T/, 2)
    when nil
      [nil, nil]
    else
      raise ArgumentError, "Invalid timestamp: #{timestamp.inspect} (expected Time, String, or nil)"
    end
  end
end
