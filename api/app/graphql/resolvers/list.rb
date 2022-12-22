# frozen_string_literal: true

module Resolvers
  module List
    class << self
      # @param model_name [String] the name of the ActiveRecord class
      # @param output_type [Class, Module] the GraphQL type to return
      # @return [Class<BaseResolver>] a resolver that can be used in a GraphQL query
      def [](
        model_name,
        output_type: default_output_type(model_name)
      )
        Class.new(BaseResolver) do |resolver|
          resolver.include(::Resolvers::List)
          resolver.description("Returns a list of #{output_type.graphql_name} objects")
          resolver.define_singleton_method(:model_class) { @model_class ||= model_name.constantize }
          resolver.type(output_type, null: true)
        end
      end

    private

      # @param model_name [String]
      # @return [Class, Module]
      def default_output_type(model_name)
        "Types::#{model_name}Type".constantize.connection_type
      end
    end

    # @!method model_class
    #   @return [Class<ActiveRecord::Base>]
    delegate :model_class, to: :class, private: true

    def resolve
      model_class.all
    end
  end
end
