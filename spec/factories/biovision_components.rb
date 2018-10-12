FactoryBot.define do
  factory :biovision_component, class: 'Biovision::Component' do
    slug { "MyString" }
    settings { "" }
  end
end
