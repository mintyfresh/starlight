# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  topic_id       :bigint           not null
#  author_id      :bigint           not null
#  last_editor_id :bigint
#  body           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#  deleted_in     :uuid
#  deleted_by_id  :bigint
#
# Indexes
#
#  index_posts_on_author_id       (author_id)
#  index_posts_on_deleted_by_id   (deleted_by_id)
#  index_posts_on_deleted_in      (deleted_in)
#  index_posts_on_last_editor_id  (last_editor_id)
#  index_posts_on_topic_id        (topic_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (deleted_by_id => users.id) ON DELETE => nullify
#  fk_rails_...  (last_editor_id => users.id) ON DELETE => nullify
#  fk_rails_...  (topic_id => topics.id)
#
require 'rails_helper'

RSpec.describe Post do
  subject(:post) { build(:post) }

  it 'has a valid factory' do
    expect(post).to be_valid
  end

  it 'is invalid without a topic' do
    post.topic = nil
    expect(post).to be_invalid
  end

  it 'is invalid without an author' do
    post.author = nil
    expect(post).to be_invalid
  end

  it 'is invalid without a body' do
    post.body = nil
    expect(post).to be_invalid
  end

  it 'is invalid when the body is too short' do
    post.body = 'a' * (described_class::BODY_MIN_LENGTH - 1)
    expect(post).to be_invalid
  end

  it 'is invalid when the body is too long' do
    post.body = 'a' * (described_class::BODY_MAX_LENGTH + 1)
    expect(post).to be_invalid
  end

  it "increments the topic's posts count when created" do
    # the topic factory also creates an initial "first post" for the topic
    expect { post.save! }.to change { post.topic.posts_count }.by(1 + 1)
  end

  it "increments the author's posts count when created" do
    expect { post.save! }.to change { post.author.posts_count }.by(1)
  end

  it "decrements the topic's posts count when soft deleted" do
    post.save!
    expect { post.destroy! }.to change { post.topic.posts_count }.by(-1)
  end

  it "decrements the author's posts count when soft deleted" do
    post.save!
    expect { post.destroy! }.to change { post.author.posts_count }.by(-1)
  end
end
