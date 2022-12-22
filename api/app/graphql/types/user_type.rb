# frozen_string_literal: true

module Types
  class UserType < BaseObject
    authorized_with_policy

    field :id, ID, null: false
    field :display_name, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
