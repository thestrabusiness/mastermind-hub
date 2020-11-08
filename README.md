# Mastermind Hub

This application is used to help keep track of Mastermind calls my friends and I
hold once a week.

## Dev Requirements

* Ruby 2.7.1
* Yarn
* PostgreSQL 11

## Setup

1. Clone the repo
1. Run `bin/setup` from the project root
1. Run `rails s` to start the server
1. Visit `localhost:3000`

## Contributing

If you want to contribute to this project: 

* Check for any open issues that need help
* Open a new issue to discuss any problems or features you're interested in


## Style checks and linting

Rubocop, erblint and eslint are included in the Gemfile and package.json you can
run them to automatically fix any issues that Hound might find:

Ruby:
`rubocop -a`

ERB Templates:
`erblint --lint-all -a`

JavaScript:
`yarn eslint app/javascript/**`
