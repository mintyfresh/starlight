# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id            :bigint           not null, primary key
#  event_id      :bigint           not null
#  player_id     :bigint           not null
#  created_by_id :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_registrations_on_created_by_id           (created_by_id)
#  index_registrations_on_event_id                (event_id)
#  index_registrations_on_event_id_and_player_id  (event_id,player_id) UNIQUE
#  index_registrations_on_player_id               (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (player_id => users.id)
#
class Registration < ApplicationRecord
  belongs_to :event, counter_cache: true, inverse_of: :registrations
  belongs_to :player, class_name: 'User', inverse_of: :registrations
  belongs_to :created_by, class_name: 'User', inverse_of: false

  has_one :check_in, dependent: :destroy, inverse_of: :registration

  has_one :decklist, dependent: :destroy, inverse_of: :registration
  accepts_nested_attributes_for :decklist, allow_destroy: true, update_only: true, reject_if: :all_blank

  publishes_messages_on :create, :destroy

  # @!method self.checked_in
  #   Returns registrations that have been checked in.
  #   @return [Class<Registration>]
  scope :checked_in, -> { where.associated(:check_in) }

  # Determines if the player has checked in for the event.
  #
  # @return [Boolean]
  def checked_in?
    check_in.present?
  end

  # Checks in the player for the event.
  # Has no effect if the player is already checked in.
  #
  # @param created_by [User] the user checking in the player
  # @return [CheckIn]
  def check_in!(created_by:)
    CheckIn.create_with(created_by:).create_or_find_by!(registration: self)
  end
end
