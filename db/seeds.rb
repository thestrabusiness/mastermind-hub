anthony = User.create(
  email: 'anthony@example.com',
  password: 'password',
  first_name: 'Anthony',
  last_name: 'Test',
  role: User::FACILITATOR
)

kurt = User.create(
  email: 'kurt@example.com',
  password: 'password',
  first_name: 'Kurt',
  last_name: 'Test'
)

User.create(
  email: 'Eric@example.com',
  password: 'password',
  first_name: 'Eric',
  last_name: 'Test'
)

group = Group.create(name: 'Fellas', facilitator: anthony)
group.users << User.all

Timer.create!(user: kurt, group: group)
