FactoryBot.define do
  factory :simple_image do
    biovision_component { nil }
    user { nil }
    agent { nil }
    ip { "" }
    name { "MyString" }
    image { "MyString" }
    image_alt_text { "MyString" }
    uuid { "" }
    source_name { "MyString" }
    source_link { "MyString" }
    caption { "MyString" }
    data { "" }
  end
end
