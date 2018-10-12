FactoryBot.define do
  factory :biovision_component_parameter, class: 'Biovision::ComponentParameter' do
    biovision { "" }
    slug { "MyString" }
    name { "MyString" }
    value { "MyText" }
    description { "MyText" }
  end
end
