# frozen_string_literal: true

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)

require "rspec/rails"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
  end
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium,
              using: :headless_chrome,
              screen_size: [1400, 1400],
              options: { url: "http://172.28.0.2:4444/wd/hub" }
  end

  config.before(:each) do
    utc = ActiveSupport::TimeZone.all.detect { |tz| tz.name == "UTC" }
    allow(Time).to receive(:zone).and_return(utc)
  end
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include ActionView::RecordIdentifier
  config.include ActiveSupport::Testing::TimeHelpers
end
