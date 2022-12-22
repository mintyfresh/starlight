# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SectionPolicy, type: :policy do
  subject(:policy) { described_class.new(current_user, section) }

  let(:section) { create(:section) }

  context 'when the user is not logged in' do
    let(:current_user) { nil }

    it { is_expected.to permit_action(:show) }
  end

  context 'when the user is logged in' do
    let(:current_user) { create(:section) }

    it { is_expected.to permit_action(:show) }
  end

  describe SectionPolicy::Scope do
    subject(:scope) { described_class.new(current_user, Section).resolve }

    before(:each) do
      create_list(:section, 3)
    end

    context 'when the user is not logged in' do
      let(:current_user) { nil }

      it 'includes all sections' do
        expect(scope).to match_array(Section.all)
      end
    end

    context 'when the user is logged in' do
      let(:current_user) { create(:section) }

      it 'includes all sections' do
        expect(scope).to match_array(Section.all)
      end
    end
  end
end
