# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    connection_type_class Types::BaseConnection
    edge_type_class Types::BaseEdge
    field_class Types::BaseField

    # @param scope_items [Boolean] whether to automatically apply policy scopes
    # @return [void]
    def self.authorized_with_policy(scope_items: true)
      define_singleton_method(:authorized?) do |object, context|
        super(object, context) && Pundit.policy!(context[:current_session]&.user, object).show?
      end

      scope_items and define_singleton_method(:scope_items) do |items, context|
        Pundit.policy_scope!(context[:current_session]&.user, items)
      end
    end
  end
end
