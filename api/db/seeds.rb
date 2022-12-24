# frozen_string_literal: true

Section.create!(title: 'General') unless Section.any?

if Rails.env.development?
  User.find_or_create_by!(email: 'test@development.com') do |user|
    user.display_name = 'Test User'
    user.credentials << UserCredential::Password.new(password: 'password')
  end
end
