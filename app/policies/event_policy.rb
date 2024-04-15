# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
  def show?
    record.published? || user == record.created_by
  end

  def update?
    user == record.created_by
  end

  def publish?
    user == record.created_by
  end

  params_filter :update do |params|
    params.permit(
      :name, :location, :description, :time_zone, :starts_at, :ends_at,
      :registration_starts_at, :registration_ends_at, :registrations_limit
    )
  end

  relation_scope do |scope|
    result = scope.published
    result = result.or(scope.where(created_by: user)) if user

    result
  end
end
