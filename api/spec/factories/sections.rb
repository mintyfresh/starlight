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
FactoryBot.define do
  factory :section do
    title { Faker::Book.title }
    description { Faker::Hipster.paragraph }
    sequence(:position) { |n| n }
  end
end
