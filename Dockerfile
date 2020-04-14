FROM ruby:latest

# yarn isn't available from the default debian repos, so we need to add it
RUN curl --silent --show-error "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update  --yes
RUN apt-get upgrade --yes
RUN apt-get install --yes libpq-dev
RUN apt-get install --yes nodejs
RUN apt-get install --yes yarn
RUN apt-get install --yes postgresql-client

ENV APP_ROOT /mastermind-hub
ENV RAILS_ENV development
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# Install gems
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle config path vendor/bundle
RUN bundle install --no-color --jobs 4 --retry 3

# Install node packages
COPY package.json $APP_ROOT/package.json
COPY yarn.lock $APP_ROOT/yarn.lock
RUN yarn install --cwd $APP_ROOT --check-files --ignore-optional --no-progress

COPY babel.config.js $APP_ROOT/babel.config.js
COPY config.ru $APP_ROOT/config.ru
COPY postcss.config.js $APP_ROO/postcss.config.js
COPY Rakefile $APP_ROOT/Rakefile

