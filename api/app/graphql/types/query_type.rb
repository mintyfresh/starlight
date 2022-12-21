# frozen_string_literal: true

module Types
  class QueryType < BaseObject
    field :current_user, UserType, null: true
    field :user, resolver: Resolvers::User

    field :section, resolver: Resolvers::Section

    # @return [User, nil]
    def current_user
      context[:current_session]&.user
    end
  end
end
