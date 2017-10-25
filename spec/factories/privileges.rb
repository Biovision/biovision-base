FactoryBot.define do
  factory :privilege do
    sequence(:name) { |n| "privilege #{n}" }
    sequence(:slug) { |n| "privilege-#{n}" }
  end
end
