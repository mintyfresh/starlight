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
    field :first_post, PostType, null: true
    field :last_post, PostType, null: true

    def section
      dataloader.with(Sources::Record, ::Section).load(object.section_id)
    end

    def author
      dataloader.with(Sources::Record, ::User).load(object.author_id)
    end

    def posts
      policy_scope(object.posts).order(:created_at, :id)
    end

    # @return [Post, nil]
    def first_post
      dataloader.with(Sources::Record, ::Post).load(first_post_id)
    end

    # @return [Post, nil]
    def last_post
      dataloader.with(Sources::Record, ::Post).load(last_post_id)
    end

  private

    # @return [Integer, nil]
    def first_post_id
      scope = ::Post.all
      scope = scope.not_deleted unless object.deleted?

      dataloader.with(Sources::Calculate, ::Post, :minimum, :id, :topic_id, scope:).load(object.id)
    end

    # @return [Integer, nil]
    def last_post_id
      scope = ::Post.all
      scope = scope.not_deleted unless object.deleted?

      dataloader.with(Sources::Calculate, ::Post, :maximum, :id, :topic_id, scope:).load(object.id)
    end
  end
end
