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

  def register?
    user.present? && record.published?
  end

  # @param params [ActionController::Parameters] the parameters to filter
  # @param extra_params [Array<Symbol, Array, Hash>] additional parameters to permit
  # @return [ActionController::Parameters]
  params_filter :update do |params, *extra_params|
    params.permit(
      :name, :location, :description, :time_zone, :starts_at, :ends_at,
      :registration_starts_at, :registration_ends_at, :registrations_limit,
      {
        announcement_config_attributes: %i[_destroy discord_channel_id],
        check_in_config_attributes:     %i[_destroy starts_at ends_at],
        payment_config_attributes:      %i[_destroy currency price],
        role_config_attributes:         %i[_destroy name permissions colour colour_as_hex hoist mentionable
                                           cleanup_delay]
      },
      *extra_params
    )
  end

  relation_scope do |scope|
    result = scope.published
    result = result.or(scope.where(created_by: user)) if user

    result
  end
end
