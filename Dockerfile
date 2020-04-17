FROM ruby:latest

# Yarn isn't available from the default debian repos, so we need to add it
RUN curl --silent --show-error "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
      libpq-dev \
      nodejs \
      yarn \
      postgresql-client \

# Install chrome dependencies
RUN apt-get install -y \
      libappindicator3-1 \
      libasound2 \
      libatk-bridge2.0-0 \
      libatk1.0-0  \
      libatspi2.0-0 \
      libcups2 \
      libdbus-1-3 \
      libdrm2 \
      libgbm1 \
      libgtk-3-0 \
      libnspr4 \
      libnss3 \
      libx11-xcb1 \
      libxcb-dri3-0 \
      libxcursor1 \
      libxdamage1 \
      libxfixes3 \
      libxi6 \
      libxrandr2 \
      libxss1 \
      libxtst6 \
      xdg-utils

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install ./google-chrome-stable_current_amd64.deb -y

ENV APP_HOME /mastermind-hub
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD package.json yarn.lock $APP_HOME/
RUN yarn install --check-files --no-progress --cwd $APP_HOME

ADD . $APP_HOME
