FactoryGirl.define do
  factory :metric_value do
    metric
    time { Time.now }
  end
end
