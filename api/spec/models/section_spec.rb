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
require 'rails_helper'

RSpec.describe Section do
  subject(:section) { build(:section) }

  it 'has a valid factory' do
    expect(section).to be_valid
  end

  it 'is invalid without a title' do
    section.title = nil
    expect(section).to be_invalid
  end

  it 'is invalid with a title longer than 100 characters' do
    section.title = 'a' * 101
    expect(section).to be_invalid
  end

  it 'is valid without a description' do
    section.description = nil
    expect(section).to be_valid
  end

  it 'is invalid with a description longer than 2500 characters' do
    section.description = 'a' * 2501
    expect(section).to be_invalid
  end

  it 'generates a position when one is not provided' do
    section.save
    expect(section.position).to be_present
  end
end
