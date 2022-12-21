# frozen_string_literal: true

module Types
  class TopicType < BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :slug, String, null: false
    field :posts_count, Integer, null: false
    field :views_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :author, UserType, null: false
    field :posts, PostType.connection_type, null: false
    field :first_post, PostType, null: false
    field :last_post, PostType, null: false

    def posts
      object.posts.order(:created_at, :id)
    end

    def first_post
      object.posts.first
    end

    def last_post
      object.posts.last
    end
  end
end
