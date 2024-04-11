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
class User < ApplicationRecord
  validates :name, presence: true
  validates :discord_user_id, presence: true
end
