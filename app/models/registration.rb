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

  has_one :decklist, dependent: :destroy, inverse_of: :registration
  accepts_nested_attributes_for :decklist, allow_destroy: true, update_only: true, reject_if: :all_blank
end
