# frozen_string_literal: true

module Sources
  class Calculate < GraphQL::Dataloader::Source
    def self.batch_key_for(model_class, function, column_name, grouping_key = model_class.primary_key, scope: nil)
      [model_class, function.to_sym, column_name.to_sym, grouping_key.to_sym, scope.try(:to_sql)]
    end

    # @param model_class [Class<ActiveRecord::Base>] the model class to load
    # @param function [Symbol] the aggregation function to use for the calculation
    # @param column_name [Symbol] the name of the column to calculate the maximum for
    # @param grouping_key [Symbol] the name of the column to group by
    # @param scope [ActiveRecord::Relation, nil] the scope to apply to the query
    def initialize(model_class, function, column_name, grouping_key = model_class.primary_key, scope: nil)
      super()
      @model_class  = model_class
      @function     = function.to_sym
      @column_name  = column_name.to_sym
      @grouping_key = grouping_key.to_sym
      @scope        = scope
    end

    # @param ids [Array<Integer>] the IDs of the records to calculate the maximum for
    # @return [Array] the maximum values
    def fetch(ids)
      records = @model_class.where_any(@grouping_key, ids).group(@grouping_key)
      records = records.merge(@scope) if @scope
      result  = records.calculate(@function, @column_name)

      ids.map { |id| result[id] }
    end
  end
end
