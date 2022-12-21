# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    connection_type_class Types::BaseConnection
    edge_type_class Types::BaseEdge
    field_class Types::BaseField

    def policy(record)
      Pundit.policy!(context[:current_user], record)
    end

    def policy_scope(scope)
      Pundit.policy_scope!(context[:current_user], scope)
    end
  end
end
