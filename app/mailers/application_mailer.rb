# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "mastermind@example.com"
  layout "mailer"
end
