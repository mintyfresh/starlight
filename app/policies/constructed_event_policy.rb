# frozen_string_literal: true

class ConstructedEventPolicy < EventPolicy
  # @param params [ActionController::Parameters] the parameters to filter
  # @param extra_params [Array<Symbol, Array, Hash>] additional parameters to permit
  # @return [ActionController::Parameters]
  params_filter :update do |params, *extra_params|
    super(
      params,
      {
        decklist_config_attributes: %i[_destroy visibility decklist_required format format_behaviour]
      },
      *extra_params
    )
  end
end
