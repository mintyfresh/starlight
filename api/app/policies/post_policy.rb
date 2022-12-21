# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  alias post record

  def show?
    !post.deleted?
  end

  class Scope < Scope
    def resolve
      scope.not_deleted
    end
  end
end
