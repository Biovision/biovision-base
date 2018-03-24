FactoryBot.define do
  factory :language do
    sequence(:slug) { |n| ((n / 17576) % 26 + 97).chr + ((n / 676) % 26 + 97).chr + ((n / 26) % 26 + 97).chr + (n % 26 + 97).chr }
    sequence(:code) { |n| ((n / 17576) % 26 + 97).chr + ((n / 676) % 26 + 97).chr + ((n / 26) % 26 + 97).chr + (n % 26 + 97).chr }
  end
end
