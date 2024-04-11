# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  discord_user_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_discord_user_id  (discord_user_id) UNIQUE
#
require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user.name = nil
    expect(user).to be_invalid
  end

  it 'is invalid without a discord user ID' do
    user.discord_user_id = nil
    expect(user).to be_invalid
  end
end
