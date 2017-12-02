FactoryBot.define do
  factory :media_folder do
    sequence(:name) { |n| "Папка #{n}" }
  end
end
