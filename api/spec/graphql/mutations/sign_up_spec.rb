# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::SignUp do
  subject(:result) { StarlightSchema.execute(query, variables:, context:) }

  let(:query) { <<~GQL }
    mutation SignUp($input: SignUpInput!) {
      signUp(input: $input) {
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
  let(:input) { graphql_input(:sign_up) }

  it 'creates a new session' do
    expect { result }.to change { UserSession.count }.by(1)
  end

  it 'returns the authenticated user', :aggregate_failures do
    data = result.dig('data', 'signUp', 'user')
    expect(data['id']).to be_present
    expect(data['displayName']).to eq(input['displayName'])
  end

  it 'returns a valid session for the user', :aggregate_failures do
    data = result.dig('data', 'signUp', 'session')
    expect(data['token']).to be_present
    expect(Time.zone.parse(data['expiresAt'])).to be_future
    expect(UserSession.find_by_token(data['token'])).to be_present
  end

  it 'returns no errors' do
    expect(result.dig('data', 'signUp', 'errors')).to be_blank
  end

  context 'when the input is invalid' do
    let(:input) { graphql_input(:sign_up, :invalid) }

    it 'does not create a new session' do
      expect { result }.not_to change { UserSession.count }
    end

    it 'returns a nil user' do
      expect(result.dig('data', 'signUp', 'user')).to be_nil
    end

    it 'returns a nil session' do
      expect(result.dig('data', 'signUp', 'session')).to be_nil
    end

    it 'returns the errors' do
      expect(result.dig('data', 'signUp', 'errors')).to eq(
        [{ 'attribute' => 'email', 'message' => 'is invalid' }]
      )
    end
  end
end
