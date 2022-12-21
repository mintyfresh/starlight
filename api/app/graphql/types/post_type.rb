# frozen_string_literal: true

module Types
  class PostType < BaseObject
    field :id, ID, null: false
    field :body, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :topic, TopicType, null: false
    field :author, UserType, null: false
  end
end
