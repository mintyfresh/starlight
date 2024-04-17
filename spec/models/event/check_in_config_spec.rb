# frozen_string_literal: true

# == Schema Information
#
# Table name: event_check_in_configs
#
#  id             :bigint           not null, primary key
#  event_id       :bigint           not null
#  time_zone      :string
#  starts_at_date :date             not null
#  starts_at_time :time             not null
#  ends_at_date   :date
#  ends_at_time   :time
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_event_check_in_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe Event::CheckInConfig do
  pending "add some examples to (or delete) #{__FILE__}"
end
