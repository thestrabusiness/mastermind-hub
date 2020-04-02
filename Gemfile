# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.0"

gem "bootsnap", ">= 1.4.2", require: false
gem "chronic", require: false
gem "clearance"
gem "dotenv-rails"
gem "factory_bot_rails"
gem "haml"
gem "haml-rails"
gem "octicons_helper"
gem "pg"
gem "pry"
gem "puma", "~> 4.3"
gem "rails", git: "https://github.com/rails/rails.git", branch: "6-0-stable"
gem "rubocop", "0.8.0", require: false
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 4.0"

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
  gem "bullet"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 4.0.0.beta"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
