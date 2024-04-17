# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  let(:context) { { user: } }

  let(:user) { create(:user) }
  let(:record) { create(:event, :published) }

  describe_rule :show? do
    succeed 'when the event is published'

    failed 'when the event is a draft' do
      let(:record) { create(:event, :draft) }

      succeed 'when the user is the creator' do
        let(:user) { record.created_by }
      end
    end
  end

  describe_rule :update? do
    failed 'when the user is not the creator'

    succeed 'when the user is the creator' do
      let(:user) { record.created_by }
    end

    failed 'when the user is not signed in' do
      let(:user) { nil }
    end
  end

  describe_rule :publish? do
    failed 'when the user is not the creator'

    succeed 'when the user is the creator' do
      let(:user) { record.created_by }
    end

    failed 'when the user is not signed in' do
      let(:user) { nil }
    end
  end

  describe_rule :register? do
    succeed 'when the event is published'

    failed 'when the event is a draft' do
      let(:record) { create(:event, :draft) }
    end

    failed 'when the user is not signed in' do
      let(:user) { nil }
    end
  end

  describe_rule :check_in? do
    succeed 'when the event is published'

    failed 'when the event is a draft' do
      let(:record) { create(:event, :draft) }
    end

    failed 'when the user is not signed in' do
      let(:user) { nil }
    end
  end

  describe 'relation scope' do
    subject(:scope) { policy.apply_scope(Event.all, type: :active_record_relation) }

    it 'includes published events' do
      expect(scope).to include(record)
    end

    context 'when an event is not published' do
      let(:record) { create(:event, :draft) }

      it 'includes draft events created by the user' do
        record.update!(created_by: user)
        expect(scope).to include(record)
      end

      it 'does not include drafts created by other users' do
        expect(scope).not_to include(record)
      end
    end
  end
end
