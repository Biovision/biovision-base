FactoryBot.define do
  factory :user_subscription do
    follower_id { 1 }
    followee_id { 1 }
  end
end
