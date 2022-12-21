# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::SignIn do
  subject(:result) { StarlightSchema.execute(query, variables:, context:) }

  let(:query) { <<~GQL }
    mutation SignIn($input: SignInInput!) {
      signIn(input: $input) {
        user {
          id
          displayName
          createdAt
        }
        session {
          token
          expiresAt
        }
        errors {
          attribute
          message
        }
      }
    }
  GQL

  let(:context) { build(:graphql_context) }
  let(:variables) { { input: } }
  let(:input) { graphql_input(:sign_in, user:) }
  let(:user) { create(:user, :with_password) }

  it 'creates a new session' do
    expect { result }.to change { UserSession.count }.by(1)
  end

  it 'returns the authenticated user', :aggregate_failures do
    data = result.dig('data', 'signIn', 'user')
    expect(data['id']).to eq(user.id.to_s)
    expect(data['displayName']).to eq(user.display_name)
    expect(data['createdAt']).to eq(user.created_at.iso8601)
  end

  it 'returns a valid session for the user', :aggregate_failures do
    data = result.dig('data', 'signIn', 'session')
    expect(data['token']).to be_present
    expect(Time.zone.parse(data['expiresAt'])).to be_future
    expect(UserSession.find_by_token(data['token'])).to have_attributes(user:)
  end

  it 'returns no errors' do
    expect(result.dig('data', 'signIn', 'errors')).to be_blank
  end

  context 'when the input is invalid' do
    let(:input) { graphql_input(:sign_in, email: '') }

    it 'does not create a new session' do
      expect { result }.not_to change { UserSession.count }
    end

    it 'returns a nil user' do
      expect(result.dig('data', 'signIn', 'user')).to be_nil
    end

    it 'returns a nil session' do
      expect(result.dig('data', 'signIn', 'session')).to be_nil
    end

    it 'returns the errors' do
      expect(result.dig('data', 'signIn', 'errors')).to eq(
        [{ 'attribute' => 'email', 'message' => "can't be blank" }]
      )
    end
  end
end
