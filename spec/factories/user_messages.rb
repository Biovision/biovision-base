FactoryBot.define do
  factory :user_message do
    uuid { "" }
    sender_id { 1 }
    receiver_id { 1 }
    sender_read { false }
    receiver_read { false }
    sender_deleted { false }
    receiver_deleted { false }
    body { "MyText" }
    data { "" }
  end
end
