FactoryGirl.define do
  factory :editable_page do
    sequence(:name) { |n| "Редактируемая страница #{n}" }
    sequence(:slug) { |n| "editable_page_#{n}" }
  end
end
