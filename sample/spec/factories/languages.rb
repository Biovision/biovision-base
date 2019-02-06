# frozen_string_literal: true

FactoryBot.define do
  factory :language do
    sequence(:slug) { |n| "language#{n}" }
    sequence(:code) { |n| "lng#{n}" }
  end
end
