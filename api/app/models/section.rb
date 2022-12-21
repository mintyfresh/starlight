# frozen_string_literal: true

# == Schema Information
#
# Table name: sections
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :string
#  position    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Section < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 2500 }

  before_create do
    self.position ||= (Section.maximum(:position) || 0) + 1
  end
end
