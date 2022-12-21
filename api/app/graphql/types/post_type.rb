# frozen_string_literal: true

module Types
  class PostType < BaseObject
    field :id, ID, null: false
    field :body, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :topic, TopicType, null: false
    field :author, UserType, null: false

    def topic
      dataloader.with(Sources::Record, ::Topic).load(object.topic_id)
    end

    def author
      dataloader.with(Sources::Record, ::User).load(object.author_id)
    end
  end
end
