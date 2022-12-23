# frozen_string_literal: true

module Sources
  class Record < BaseSource
    # @param model_class [Class<ActiveRecord::Base>] the model class to load
    # @param column_name [Symbol] the key by which to load the records
    def initialize(model_class, column_name = model_class.primary_key)
      super()

      @model_class = model_class
      @column_name = column_name.to_sym
      @column_type = model_class.type_for_attribute(column_name)
    end

    # @param ids [Array<Integer>] the IDs of the records to load
    # @return [Array<ActiveRecord::Base, nil>] the loaded records
    def fetch(ids)
      records = @model_class.where_any(@column_name, ids)
      index   = records.index_by(&@column_name)

      ids.map { |id| index[@column_type.cast(id)] }
    end
  end
end
