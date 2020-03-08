FactoryBot.define do
  factory :user do
    first_name { 'Elon' }
    sequence(:last_name) { |n| "Musk#{n}" }
    sequence(:email) { |n| "elon#{n}@example.com" }
    password { 'password' }

    trait :facilitator do
      after(:create) do |user, _|
        group = create(:group, creator: user)
        group.memberships.create(user: user, role: Membership::FACILITATOR)
      end
    end

    trait :with_group do
      after(:create) do |user, _|
        group = create(:group, creator: user)
        group.users << user
      end
    end
  end

  factory :group do
    sequence(:name) { |n| "Group #{n}" }
    association :creator, factory: :user
  end

  factory :timer do
    association :user
    association :call
  end

  factory :group_invite do
    sequence(:email) { |n| "email#{n}@example.com" }
    association :group
  end

  factory :call do
    scheduled_on { Time.current }
    association :group
  end

  factory :commitment do
    body { 'I commit to doing a thing' }
    association :membership

    trait :completed do
      completed { true }
    end
  end

end
