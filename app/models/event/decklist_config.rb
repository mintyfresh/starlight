# frozen_string_literal: true

# == Schema Information
#
# Table name: event_decklist_configs
#
#  id                :bigint           not null, primary key
#  event_id          :bigint           not null
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
    FORMATS = %w[
      core
      adventure
      harmony
      nightmare
      chaos
      custom
    ].freeze

    # @type [Array<String>]
    FORMAT_BEHAVIOURS = %w[
      reject_invalid
      require_approval
      accept_invalid
    ].freeze

    belongs_to :event

    validates :decklist_required, inclusion: { in: [true, false] }
    validates :format, inclusion: { in: FORMATS, allow_nil: true }
    validates :format_behaviour, inclusion: { in: FORMAT_BEHAVIOURS, allow_nil: true }
    validates :format_behaviour, presence: true, if: -> { format.present? }

    before_save if: -> { format_changed?(to: nil) } do
      self.format_behaviour = nil
    end

    # @param format [String]
    # @return [String]
    def self.human_format_name(format)
      human_attribute_name("format/#{format}")
    end

    # @param behaviour [String]
    # @return [String]
    def self.human_behaviour_name(behaviour)
      human_attribute_name("format_behaviour/#{behaviour}")
    end

    # @return [String, nil]
    def human_format_name
      format && self.class.human_format_name(format)
    end

    # @return [String, nil]
    def human_behaviour_name
      format_behaviour && self.class.human_behaviour_name(format_behaviour)
    end
  end
end
