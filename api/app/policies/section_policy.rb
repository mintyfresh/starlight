# frozen_string_literal: true

class SectionPolicy < ApplicationPolicy
  alias section record

  def show?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
