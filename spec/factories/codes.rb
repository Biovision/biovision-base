FactoryGirl.define do
  factory :code do
    category Code.categories.values.first

    factory :recovery_code do
      association :user, factory: :user
      category Code.categories[:recovery]
    end

    factory :confirmation_code do
      association :user, factory: :user
      category Code.categories[:confirmation]
    end

    factory :invitation_code do
      association :user, factory: :confirmed_user
      category Code.categories[:invitation]
    end
  end
end
