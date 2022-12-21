# frozen_string_literal: true

class StarlightSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  use(GraphQL::Dataloader)

  # Union and Interface Resolution
  def self.resolve_type(_abstract_type, object, _context)
    "Types::#{object.class.name}Type".constantize
  end

  # Stop validating when it encounters this many errors:
  validate_max_errors(100)
end
