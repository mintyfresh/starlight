# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  alias user record

  def show?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
