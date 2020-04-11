FROM ruby:latest

# yarn isn't available from the default debian repos, so we need to add it
RUN curl --silent --show-error "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update  --yes
RUN apt-get upgrade --yes
RUN apt-get install --yes nodejs
RUN apt-get install --yes yarn
RUN apt-get install --yes postgresql-client

ENV APP_ROOT /mastermind-hub
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# Install gems
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install --no-color

# Install node packages
COPY package.json $APP_ROOT/package.json
COPY yarn.lock $APP_ROOT/yarn.lock
RUN yarn install --cwd $APP_ROOT --check-files --ignore-optional --no-progress

# Copy the Rails application and configuration files
COPY app $APP_ROOT/app
COPY bin $APP_ROOT/bin
COPY config $APP_ROOT/config
COPY db $APP_ROOT/db
COPY public $APP_ROOT/public

COPY .env $APP_ROOT/.env
COPY babel.config.js $APP_ROOT/babel.config.js
COPY config.ru $APP_ROOT/config.ru
COPY postcss.config.js $APP_ROO/postcss.config.js
COPY Rakefile $APP_ROOT/Rakefile

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
