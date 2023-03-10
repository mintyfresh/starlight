# frozen_string_literal: true

module Types
  module BaseInterface
    include GraphQL::Schema::Interface

    connection_type_class Types::BaseConnection
    edge_type_class Types::BaseEdge
    field_class Types::BaseField
  end
end
