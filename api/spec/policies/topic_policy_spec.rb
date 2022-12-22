# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TopicPolicy, type: :policy do
  subject(:policy) { described_class.new(current_user, topic) }

  let(:topic) { create(:topic) }

  context 'when the user is not logged in' do
    let(:current_user) { nil }

    it { is_expected.to permit_action(:show) }

    context 'when the topic is deleted' do
      let(:topic) { create(:topic, :deleted) }

      it { is_expected.to forbid_action(:show) }
    end
  end

  context 'when the user is logged in' do
    let(:current_user) { create(:user) }

    it { is_expected.to permit_action(:show) }

    context 'when the topic is deleted' do
      let(:topic) { create(:topic, :deleted) }

      it { is_expected.to forbid_action(:show) }
    end
  end

  describe TopicPolicy::Scope do
    subject(:scope) { described_class.new(current_user, Topic).resolve }

    before(:each) do
      create_list(:topic, 3)
    end

    context 'when the user is not logged in' do
      let(:current_user) { nil }

      it 'includes all topics' do
        expect(scope).to match_array(Topic.all)
      end

      it 'does not include deleted topics' do
        topic = Topic.all.sample.tap(&:destroy!)
        expect(scope).not_to include(topic)
      end
    end

    context 'when the user is logged in' do
      let(:current_user) { create(:user) }

      it 'includes all topics' do
        expect(scope).to match_array(Topic.all)
      end

      it 'does not include deleted topics' do
        topic = Topic.all.sample.tap(&:destroy!)
        expect(scope).not_to include(topic)
      end
    end
  end
end
