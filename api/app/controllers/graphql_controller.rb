# frozen_string_literal: true

class GraphqlController < ApplicationController
  if Rails.env.development?
    rescue_from StandardError do |error|
      logger.error(error.message)
      logger.error(error.backtrace.join("\n"))

      render json:   { errors: [{ message: error.message, backtrace: error.backtrace }], data: {} },
             status: :internal_server_error
    end
  end

  def execute
    variables      = prepare_variables(params[:variables])
    query          = params[:query]
    operation_name = params[:operationName]
    context        = build_context

    render json: StarlightSchema.execute(query, variables:, context:, operation_name:)
  end

private

  # @return [Hash]
  def build_context
    { ip:              request.ip,
      remote_ip:       request.remote_ip,
      request_id:      request.uuid,
      user_agent:      request.user_agent,
      current_session: }
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String, nil
      variables_param.present? ? JSON.parse(variables_param) || {} : {}
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end
end
