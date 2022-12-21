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

    field :section, SectionType, null: false
    field :author, UserType, null: false
    field :posts, PostType.connection_type, null: false
    field :first_post, PostType, null: false
    field :last_post, PostType, null: false

    def section
      dataloader.with(Sources::Record, ::Section).load(object.section_id)
    end

    def author
      dataloader.with(Sources::Record, ::User).load(object.author_id)
    end

    def posts
      object.posts.order(:created_at, :id)
    end

    def first_post
      dataloader.with(Sources::Record, ::Post).load(first_post_id)
    end

    def last_post
      dataloader.with(Sources::Record, ::Post).load(last_post_id)
    end

  private

    def first_post_id
      dataloader.with(Sources::Calculate, ::Post, :minimum, :id, :topic_id).load(object.id)
    end

    def last_post_id
      dataloader.with(Sources::Calculate, ::Post, :maximum, :id, :topic_id).load(object.id)
    end
  end
end
