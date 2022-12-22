# frozen_string_literal: true

module Resolvers
  class Sections < List['Section']
    def resolve
      super.order(:position, :id)
    end
  end
end
