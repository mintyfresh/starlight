# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::SignOut do
  subject(:result) { StarlightSchema.execute(query, context:) }

  let(:query) { <<~GQL }
    mutation SignOut {
      signOut {
        success
      }
    }
  GQL

  let!(:context) { build(:graphql_context, :signed_in) }

  it 'revokes the current session' do
    current_session = context[:current_session]
    expect { result }.to change { current_session.revoked? }.from(false).to(true)
  end

  it 'returns success' do
    expect(result.dig('data', 'signOut', 'success')).to be(true)
  end

  context 'when the user is not signed in' do
    let(:context) { build(:graphql_context) }

    it 'returns success' do
      expect(result.dig('data', 'signOut', 'success')).to be(true)
    end
  end
end
