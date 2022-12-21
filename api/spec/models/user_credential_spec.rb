# frozen_string_literal: true

# == Schema Information
#
# Table name: user_credentials
#
#  id          :bigint           not null, primary key
#  type        :string           not null
#  user_id     :bigint           not null
#  external_id :string
#  data        :jsonb
#  expires_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_credentials_on_type_and_external_id  (type,external_id) UNIQUE
#  index_user_credentials_on_type_and_user_id      (type,user_id) UNIQUE
#  index_user_credentials_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe UserCredential do
  subject(:user_credential) { build(:user_credential) }

  it 'has a valid factory' do
    expect(user_credential).to be_valid
  end

  it 'is invalid without a type' do
    user_credential.type = nil
    expect { user_credential.validate }.to raise_error(ActiveModel::StrictValidationFailed)
  end

  it 'is invalid without a user' do
    user_credential.user = nil
    expect(user_credential).to be_invalid
  end
end
