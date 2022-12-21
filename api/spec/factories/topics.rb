# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id            :bigint           not null, primary key
#  section_id    :bigint           not null
#  author_id     :bigint           not null
#  title         :string           not null
#  posts_count   :integer          default(0), not null
#  views_count   :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  deleted_in    :uuid
#  deleted_by_id :bigint           not null
#
# Indexes
#
#  index_topics_on_author_id      (author_id)
#  index_topics_on_deleted_by_id  (deleted_by_id)
#  index_topics_on_deleted_in     (deleted_in)
#  index_topics_on_section_id     (section_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (deleted_by_id => users.id)
#  fk_rails_...  (section_id => sections.id)
#
FactoryBot.define do
  factory :topic do
    association :section
    association :author, factory: :user

    title { Faker::Book.title }

    trait :deleted do
      deleted_at { Time.current }
      deleted_in { SecureRandom.uuid }
      association :deleted_by, factory: :user
    end
  end
end
