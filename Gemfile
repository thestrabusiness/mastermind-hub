# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

gem "bootsnap", ">= 1.4.2", require: false
gem "chronic", require: false
gem "clearance"
gem "delayed"
gem "dotenv-rails"
gem "erb_lint", "0.0.29", require: false
gem "factory_bot_rails"
gem "foreman"
gem "octicons_helper"
gem "pg"
gem "pry"
gem "puma", "~> 5"
gem "rails", "~> 7.0.1"
gem "rubocop", "0.80.0", require: false
gem "sass-rails", ">= 6"
gem "solargraph"
gem "sprockets-rails"
gem "turbolinks", "~> 5"
gem "webpacker"

group :production do
  gem "redis"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 4.0.0.beta"
  gem "shoulda-matchers"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
