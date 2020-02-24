FactoryBot.define do
  factory :user do
    first_name { 'Elon' }
    sequence(:last_name) { |n| "Musk#{n}" }
    sequence(:email) { |n| "elon#{n}@example.com" }
    password { 'password' }

    trait :facilitator do
      role { User::FACILITATOR }
    end

    trait :with_group do
      after(:create) do |user, _|
        group = create(:group, facilitator: user)
        group.users << user
      end
    end
  end

  factory :group do
    sequence(:name) { |n| "Group #{n}" }
    association :facilitator, factory: :user
  end

  factory :timer do
    association :user
    association :group
  end

  factory :group_invite do
    sequence(:email) { |n| "email#{n}@example.com" }
    association :group
  end
end
