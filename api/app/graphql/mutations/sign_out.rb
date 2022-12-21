# frozen_string_literal: true

module Mutations
  class SignOut < BaseMutation
    field :success, Boolean, null: false

    def resolve
      context[:current_session]&.revoke!
      context[:current_session] = nil

      { success: true }
    end
  end
end
