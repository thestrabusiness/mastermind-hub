require 'chronic'

admin = User.create!(
  email: 'admin@example.com',
  password: 'password',
  first_name: 'Admin',
  last_name: 'Istrator'
)

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

group = Group.create!(name: 'Fellas', creator: admin, call_time: '16:00')
group.memberships.create!(user: admin, role: Membership::FACILITATOR)
group.users << [anthony, eric, kurt, tad, joe]

upcoming_call = group.upcoming_call
todays_call = group
  .calls
  .create!(scheduled_on: upcoming_call.scheduled_on - 7.days)
previous_call = group
  .calls
  .create!(scheduled_on: upcoming_call.scheduled_on - 14.days)

group.memberships.each do |member|
  body = "#{member.user.first_name}'s commitment"
  previous_call.commitments.create!(membership: member, body: body)
end

Timer.create!(user: kurt, call: todays_call)
