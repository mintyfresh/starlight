# frozen_string_literal: true

module Sources
  class Record < BaseSource
    # @param model_class [Class<ActiveRecord::Base>] the model class to load
    def initialize(model_class, primary_key = model_class.primary_key)
      super()

      @model_class = model_class
      @primary_key = primary_key.to_sym
      @column_type = model_class.type_for_attribute(primary_key)
    end

    # @param ids [Array<Integer>] the IDs of the records to load
    # @return [Array<ActiveRecord::Base, nil>] the loaded records
    def fetch(ids)
      records = @model_class.where_any(@primary_key, ids)
      index   = records.index_by(&@primary_key)

      ids.map { |id| index[@column_type.cast(id)] }
    end
  end
end
