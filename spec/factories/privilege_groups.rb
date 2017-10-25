FactoryBot.define do
  factory :privilege_group do
    sequence(:name) { |n| "Группа привилегий #{n}" }
    sequence(:slug) { |n| "privilege-group-#{n}" }
  end
end
