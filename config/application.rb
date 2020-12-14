# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MastermindHub
  class Application < Rails::Application
    config.load_defaults 6.1
    config.action_mailer.default_url_options = { host: ENV.fetch("APPLICATION_HOST") }
    config.active_job.queue_adapter = :delayed_job
  end
end
