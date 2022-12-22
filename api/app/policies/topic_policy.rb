# frozen_string_literal: true

class TopicPolicy < ApplicationPolicy
  alias topic record

  def show?
    !topic.deleted?
  end

  class Scope < Scope
    def resolve
      scope.not_deleted
    end
  end
end
