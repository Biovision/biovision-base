FactoryBot.define do
  factory :simple_block do
    language { nil }
    visible { false }
    background_image { false }
    slug { "MyString" }
    name { "MyString" }
    image { "MyString" }
    image_alt_text { "MyString" }
    body { "MyText" }
  end
end
