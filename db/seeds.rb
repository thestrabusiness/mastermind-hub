anthony = User.create(
  email: 'anthony@example.com',
  password: 'password',
  first_name: 'Anthony',
  last_name: 'Test'
)

kurt = User.create(
  email: 'kurt@example.com',
  password: 'password',
  first_name: 'Kurt',
  last_name: 'Test'
)

eric = User.create(
  email: 'Eric@example.com',
  password: 'password',
  first_name: 'Eric',
  last_name: 'Test'
)

group = Group.create(name: 'Fellas', creator: anthony)
group.memberships.create(user: anthony, role: Membership::FACILITATOR)
group.users << [kurt, eric]

Timer.create!(user: kurt, group: group)
