# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend HasUniqueAttribute

  primary_abstract_class

  delegate :human_attribute_name, to: :class
end
