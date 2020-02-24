FactoryBot.define do
  factory :user do
    first_name { 'Elon' }
    sequence(:last_name) { |n| "Musk#{n}" }
    sequence(:email) { |n| "elon#{n}@example.com" }
    password { 'password' }

    trait :facilitator do
      role { User::FACILITATOR }
    end
  end

  factory :timer do
    association :user
    association :facilitator, factory: :user
  end
end
