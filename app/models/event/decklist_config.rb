# frozen_string_literal: true

# == Schema Information
#
# Table name: event_decklist_configs
#
#  id                :bigint           not null, primary key
#  event_id          :bigint           not null
#  visibility        :string           not null
#  decklist_required :boolean          default(FALSE), not null
#  format            :string
#  format_behaviour  :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_event_decklist_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class Event
  class DecklistConfig < ApplicationRecord
    # @type [Array<String>]
    VISIBILITIES = %w[
      judges_only
      other_players
      everyone
    ].freeze

    # @type [Array<String>]
    FORMATS = %w[
      core
      adventure
      harmony
    ].freeze

    # @type [Array<String>]
    FORMAT_BEHAVIOURS = %w[
      reject_invalid
      accept_invalid
    ].freeze

    normalizes :format, :format_behaviour, with: -> (value) { value.presence }

    belongs_to :event

    validates :visibility, inclusion: { in: VISIBILITIES }
    validates :decklist_required, inclusion: { in: [true, false] }
    validates :format, inclusion: { in: FORMATS, allow_nil: true }
    validates :format_behaviour, inclusion: { in: FORMAT_BEHAVIOURS, allow_nil: true }
    validates :format_behaviour, presence: true, if: -> { format.present? }

    before_save if: -> { format_changed?(to: nil) } do
      self.format_behaviour = nil
    end

    # @param visibility [String]
    # @return [String]
    def self.human_visibility_name(visibility)
      human_attribute_name("visibility/#{visibility}")
    end

    # @param format [String]
    # @return [String]
    def self.human_format_name(format)
      human_attribute_name("format/#{format}")
    end

    # @param behaviour [String]
    # @return [String]
    def self.human_format_behaviour_name(behaviour)
      human_attribute_name("format_behaviour/#{behaviour}")
    end

    # @return [String, nil]
    def human_visibility_name
      visibility && self.class.human_visibility_name(visibility)
    end

    # @return [String, nil]
    def human_format_name
      format && self.class.human_format_name(format)
    end

    # @return [String, nil]
    def human_format_behaviour_name
      format_behaviour && self.class.human_format_behaviour_name(format_behaviour)
    end
  end
end
