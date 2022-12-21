# frozen_string_literal: true

module Types
  class MutationType < BaseObject
    field :sign_in, mutation: Mutations::SignIn
  end
end
