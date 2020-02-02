FactoryBot.define do
  factory :notification do
    biovision_component { nil }
    user { nil }
    email_sent { false }
    read { false }
    data { "" }
  end
end
