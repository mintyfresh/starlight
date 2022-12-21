# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    connection_type_class Types::BaseConnection
    edge_type_class Types::BaseEdge
    field_class Types::BaseField
  end
end
