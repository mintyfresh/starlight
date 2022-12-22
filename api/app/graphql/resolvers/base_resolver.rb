# frozen_string_literal: true

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    argument_class Types::BaseArgument

    def policy(record)
      Pundit.policy!(context[:current_session]&.user, record)
    end

    def policy_scope(scope)
      Pundit.policy_scope!(context[:current_session]&.user, scope)
    end
  end
end
