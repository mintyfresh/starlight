# frozen_string_literal: true

module Mutations
  class SignUp < BaseMutation
    argument :input, Types::SignUpInputType, required: true

    field :user, Types::UserType, null: true
    field :session, Types::UserSessionType, null: true
    field :errors, [Types::ErrorType], null: true

    def resolve(input:)
      sign_up = ::SignUp.new(input.to_h)
      sign_up.ip = context[:ip]

      if (session = sign_up.call)
        context[:current_session] = session

        { user: session.user, session: }
      else
        { errors: sign_up.errors }
      end
    end
  end
end
