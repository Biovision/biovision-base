FactoryGirl.define do
  factory :code do
    code_type

    factory :recovery_code do
      association :user, factory: :user
    end

    factory :confirmation_code do
      association :user, factory: :user
    end

    factory :invitation_code do
      association :user, factory: :confirmed_user
    end
  end
end
