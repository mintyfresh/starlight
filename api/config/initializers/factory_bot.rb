# frozen_string_literal: true

if defined?(FactoryBot)
  class GraphQLInputStrategy
    def initialize
      @strategy = FactoryBot.strategy_by_name(:attributes_for).new
    end

    delegate :association, to: :@strategy

    def result(evaluation)
      @strategy.result(evaluation).deep_transform_keys! do |key|
        key.to_s.camelize(:lower)
      end
    end

    def to_sym
      :graphql_input
    end
  end

  FactoryBot.register_strategy(:graphql_input, GraphQLInputStrategy)
end
