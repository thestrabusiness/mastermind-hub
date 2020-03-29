require 'chronic'

anthony = User.create!(
  email: 'anthony@example.com',
  password: 'password',
  first_name: 'Anthony',
  last_name: 'Test'
)

kurt = User.create!(
  email: 'kurt@example.com',
  password: 'password',
  first_name: 'Kurt',
  last_name: 'Test'
)

eric = User.create!(
  email: 'Eric@example.com',
  password: 'password',
  first_name: 'Eric',
  last_name: 'Test'
)

joe = User.create!(
  email: 'Joe@example.com',
  password: 'password',
  first_name: 'Joe',
  last_name: 'Test'
)

tad = User.create!(
  email: 'Tad@example.com',
  password: 'password',
  first_name: 'Tad',
  last_name: 'Test'
)

group = Group.create!(name: 'Fellas', creator: anthony, call_time: '16:00')
group.memberships.create!(user: anthony, role: Membership::FACILITATOR)
group.users << [kurt, eric, tad, joe]

last_call = group.calls.create!(scheduled_on: Date.current - 7.days)
todays_call = group.calls.create!(scheduled_on: Date.current)
group.calls.create!(scheduled_on: Date.current - 14.days)

group.memberships.each do |member|
  body = "#{member.user.first_name}'s commitment"
  last_call.commitments.create!(membership: member, body: body)
end

Timer.create!(user: kurt, call: todays_call)
