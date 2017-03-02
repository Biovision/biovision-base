FactoryGirl.define do
  factory :browser do
    sequence(:name) { |n| "Browser #{n}" }
  end
end
