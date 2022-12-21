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
class Post < ApplicationRecord
  BODY_MIN_LENGTH = 10
  BODY_MAX_LENGTH = 25_000

  include SoftDeletable

  belongs_to :topic, counter_cache: true, inverse_of: :posts
  belongs_to :author, class_name: 'User', counter_cache: true, inverse_of: :authored_posts
  belongs_to :last_editor, class_name: 'User', inverse_of: false, optional: true

  validates :body, presence: true, length: { minimum: BODY_MIN_LENGTH, maximum: BODY_MAX_LENGTH }
end
