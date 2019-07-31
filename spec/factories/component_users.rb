FactoryBot.define do
  factory :BiovisionComponentUser do
    component { nil }
    user { nil }
    administrator { false }
    data { "" }
  end
end
