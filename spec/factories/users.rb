FactoryGirl.define do
  factory :user do
    sequence(:screen_name) { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'secret'
    password_confirmation 'secret'

    factory :confirmed_user do
      email_confirmed true
    end
  end
end
