# frozen_string_literal: true

class RegistrationPolicy < ApplicationPolicy
  params_filter :create do |params|
    params.permit(decklist_attributes: %i[_destroy deck_name ponyhead_url])
  end
end
