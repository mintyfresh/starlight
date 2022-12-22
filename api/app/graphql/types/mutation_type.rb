# frozen_string_literal: true

module Types
  class MutationType < BaseObject
    field :sign_in,  mutation: Mutations::SignIn
    field :sign_out, mutation: Mutations::SignOut
    field :sign_up,  mutation: Mutations::SignUp
  end
end
