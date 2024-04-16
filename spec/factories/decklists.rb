# frozen_string_literal: true

# == Schema Information
#
# Table name: decklists
#
#  id              :bigint           not null, primary key
#  registration_id :bigint           not null
#  deck_name       :string
#  ponyhead_url    :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_decklists_on_registration_id  (registration_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (registration_id => registrations.id)
#
FactoryBot.define do
  factory :decklist do
    registration
    deck_name { Faker::Book.title }
    ponyhead_url { <<~URL.strip }
      https://ponyhead.com/deckbuilder?v1code=fm159x3-nd156x3-ll146x3-sb142x2-ll126x2-sb116x3-sb141x3-sb110x3-nd154x3-ff94x3-de135x3-ll16x2-nd141x1-fm89x3-fm15x3-fm86x2-fm93x3-ll132x1-fm141x2-fm138x2-nd137x2-ll128x1-pw13x3-nd159x2-ff141x3
    URL

    trait :with_short_url do
      ponyhead_url { 'https://ponyhead.com/d/plF_KKlZ0qhMjjxiNGH6YSpYcuJZWeCxX-M6iVeUVqppw' }
    end
  end
end
