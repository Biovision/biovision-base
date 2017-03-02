FactoryGirl.define do
  factory :agent do
    sequence(:name) { |n| "Agent #{n}" }
  end
end
