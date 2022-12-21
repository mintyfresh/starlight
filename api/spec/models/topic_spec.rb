# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id            :bigint           not null, primary key
#  section_id    :bigint           not null
#  author_id     :bigint           not null
#  title         :string           not null
#  posts_count   :integer          default(0), not null
#  views_count   :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  deleted_in    :uuid
#  deleted_by_id :bigint
#
# Indexes
#
#  index_topics_on_author_id      (author_id)
#  index_topics_on_deleted_by_id  (deleted_by_id)
#  index_topics_on_deleted_in     (deleted_in)
#  index_topics_on_section_id     (section_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (deleted_by_id => users.id) ON DELETE => nullify
#  fk_rails_...  (section_id => sections.id)
#
require 'rails_helper'

RSpec.describe Topic do
  subject(:topic) { build(:topic) }

  it 'has a valid factory' do
    expect(topic).to be_valid
  end

  it 'is invalid without a section' do
    topic.section = nil
    expect(topic).to be_invalid
  end

  it 'is invalid without an author' do
    topic.author = nil
    expect(topic).to be_invalid
  end

  it 'is invalid without a title' do
    topic.title = nil
    expect(topic).to be_invalid
  end

  it 'is invalid with a title longer than 100 characters' do
    topic.title = 'a' * 101
    expect(topic).to be_invalid
  end
end
