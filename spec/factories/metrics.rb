FactoryGirl.define do
  factory :metric do
    sequence(:name) { |n| "test.#{n}" }
  end
end
