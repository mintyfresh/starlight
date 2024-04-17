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
FactoryBot.define do
  factory :registration do
    event
    player factory: :user
    created_by { player }

    trait :with_decklist do
      decklist { association(:decklist, registration: instance) }
    end

    trait :with_check_in do
      check_in { association(:check_in, registration: instance) }
    end
  end
end
