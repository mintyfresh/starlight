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
require 'rails_helper'

RSpec.describe CheckIn do
  subject(:check_in) { build(:check_in) }

  it 'has a valid factory' do
    expect(check_in).to be_valid
  end

  it 'is invalid without a registration' do
    check_in.registration = nil
    expect(check_in).to be_invalid
  end

  it 'is invalid without a creator' do
    check_in.created_by = nil
    expect(check_in).to be_invalid
  end
end
