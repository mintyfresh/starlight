# frozen_string_literal: true

# == Schema Information
#
# Table name: event_check_in_configs
#
#  id             :bigint           not null, primary key
#  event_id       :bigint           not null
#  time_zone      :string
#  starts_at_date :date             not null
#  starts_at_time :time             not null
#  ends_at_date   :date
#  ends_at_time   :time
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_event_check_in_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class Event
  class CheckInConfig < ApplicationRecord
    self.ignored_columns += %w[starts_at ends_at]

    attribute :starts_at_time, :time_only
    attribute :ends_at_time, :time_only

    belongs_to :event, inverse_of: :check_in_config

    timestamps_from_parts :starts_at, :ends_at, time_zone: :time_zone

    before_validation do
      self.time_zone = event.try(:time_zone)
    end

    validates :starts_at, presence: true

    # event check-in must start before it ends
    validates :starts_at, before_attribute: :ends_at

    # event check-in must start before the event starts
    validates :starts_at, before_attribute: :event_starts_at

    # event check-in must end before the event ends
    validates :ends_at, before_attribute: :event_ends_at

    # @!method self.open
    #   @return [Class<Event::CheckInConfig>]
    scope :open, lambda {
      now = bind_param('now', Time.current)
      ends_at = Arel::Nodes::NamedFunction.new('COALESCE', [arel_table[:ends_at], Event.arel_table[:starts_at]])

      joins(:event)
        .where(arel_table[:starts_at].lteq(now))
        .where(ends_at.gt(now))
    }

    # @!method event_starts_at
    #   @return [Time, nil]
    # @!method event_ends_at
    #   @return [Time, nil]
    delegate :starts_at, :ends_at, to: :event, prefix: true

    # Determines if check-in is open.
    #
    # @return [Boolean]
    def open?
      starts_at.present? && (ends_at || event_starts_at).present? &&
        Time.current.between?(starts_at, ends_at || event_starts_at)
    end
  end
end
