# frozen_string_literal: true

module Mutations
  class SignIn < BaseMutation
    argument :input, Types::SignInInputType, required: true

    field :user, Types::UserType, null: true
    field :session, Types::UserSessionType, null: true
    field :errors, [Types::ErrorType], null: true

    def resolve(input:)
      sign_in = ::SignIn.new(input.to_h)
      sign_in.ip = context[:ip]

      if (session = sign_in.call)
        context[:current_session] = session

        { user: session.user, session: }
      else
        { errors: sign_in.errors }
      end
    end
  end
end
