# frozen_string_literal: true

# == Schema Information
#
# Table name: check_ins
#
#  id              :bigint           not null, primary key
#  registration_id :bigint           not null
#  created_by_id   :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_check_ins_on_created_by_id    (created_by_id)
#  index_check_ins_on_registration_id  (registration_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (registration_id => registrations.id)
#
class CheckIn < ApplicationRecord
  belongs_to :registration, inverse_of: :check_in
  belongs_to :created_by, class_name: 'User', inverse_of: false

  has_one :event, through: :registration
end
