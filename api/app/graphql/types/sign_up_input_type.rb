# frozen_string_literal: true

module Types
  class SignUpInputType < BaseInputObject
    argument :email, String, required: true
    argument :display_name, String, required: true
    argument :password, String, required: true
  end
end
