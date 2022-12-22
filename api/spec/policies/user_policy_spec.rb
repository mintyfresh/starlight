# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject(:policy) { described_class.new(current_user, user) }

  let(:user) { create(:user) }

  context 'when the user is not logged in' do
    let(:current_user) { nil }

    it { is_expected.to permit_action(:show) }
  end

  context 'when the user is logged in' do
    let(:current_user) { create(:user) }

    it { is_expected.to permit_action(:show) }
  end

  describe UserPolicy::Scope do
    subject(:scope) { described_class.new(current_user, User).resolve }

    before(:each) do
      create_list(:user, 3)
    end

    context 'when the user is not logged in' do
      let(:current_user) { nil }

      it 'includes all users' do
        expect(scope).to match_array(User.all)
      end
    end

    context 'when the user is logged in' do
      let(:current_user) { create(:user) }

      it 'includes all users' do
        expect(scope).to match_array(User.all)
      end
    end
  end
end
