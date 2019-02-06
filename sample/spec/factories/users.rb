# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:screen_name) { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'secret' }
    password_confirmation { 'secret' }
  end
end
