# frozen_string_literal: true

module Webhooks
  class BaseController < ActionController::API
    wrap_parameters false
  end
end
