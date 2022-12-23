# frozen_string_literal: true

module Sources
  class Calculate < GraphQL::Dataloader::Source
    def self.batch_key_for(model_class, function, measure_column_name,
                           group_column_name = model_class.primary_key, scope: nil)
      [model_class, function.to_sym, measure_column_name.to_sym, group_column_name.to_sym, scope.try(:to_sql)]
    end

    # @param model_class [Class<ActiveRecord::Base>] the model class to load
    # @param function [Symbol] the aggregation function to use for the calculation
    # @param measure_column_name [Symbol] the name of the column to calculate the maximum for
    # @param group_column_name [Symbol] the name of the column to group by
    # @param scope [ActiveRecord::Relation, nil] the scope to apply to the query
    def initialize(model_class, function, measure_column_name, group_column_name = model_class.primary_key, scope: nil)
      super()
      @model_class         = model_class
      @function            = function.to_sym
      @measure_column_name = measure_column_name.to_sym
      @group_column_name   = group_column_name.to_sym
      @group_column_type   = model_class.type_for_attribute(group_column_name)
      @scope               = scope
    end

    # @param ids [Array<Integer>] the IDs of the records to calculate the maximum for
    # @return [Array] the maximum values
    def fetch(ids)
      records = @model_class.where_any(@group_column_name, ids).group(@group_column_name)
      records = records.merge(@scope) if @scope
      result  = records.calculate(@function, @measure_column_name)

      ids.map { |id| result[@group_column_type.cast(id)] }
    end
  end
end
