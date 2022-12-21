# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostPolicy, type: :policy do
  subject(:policy) { described_class.new(current_user, post) }

  let(:post) { create(:post) }

  context 'when the user is not logged in' do
    let(:current_user) { nil }

    it { is_expected.to permit_action(:show) }

    context 'when the post is deleted' do
      let(:post) { create(:post, :deleted) }

      it { is_expected.to forbid_action(:show) }
    end
  end

  context 'when the user is logged in' do
    let(:current_user) { create(:user) }

    it { is_expected.to permit_action(:show) }

    context 'when the post is deleted' do
      let(:post) { create(:post, :deleted) }

      it { is_expected.to forbid_action(:show) }
    end
  end

  describe PostPolicy::Scope do
    subject(:scope) { described_class.new(current_user, Post).resolve }

    before(:each) do
      create_list(:post, 3)
    end

    context 'when the user is not logged in' do
      let(:current_user) { nil }

      it 'includes all posts' do
        expect(scope).to match_array(Post.all)
      end

      it 'does not include deleted posts' do
        post = Post.all.sample.tap(&:destroy!)
        expect(scope).not_to include(post)
      end
    end

    context 'when the user is logged in' do
      let(:current_user) { create(:user) }

      it 'includes all posts' do
        expect(scope).to match_array(Post.all)
      end

      it 'does not include deleted posts' do
        post = Post.all.sample.tap(&:destroy!)
        expect(scope).not_to include(post)
      end
    end
  end
end
