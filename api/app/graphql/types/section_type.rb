# frozen_string_literal: true

module Types
  class SectionType < BaseObject
    authorized_with_policy

    field :id, ID, null: false
    field :title, String, null: false
    field :slug, String, null: false
    field :description, String, null: true
    field :position, Integer, null: false

    field :topics, TopicType.connection_type, null: false

    def topics
      object.topics.order(updated_at: :desc, id: :desc)
    end
  end
end
