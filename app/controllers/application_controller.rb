# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Clearance::Controller

  before_action :set_time_zone

  def set_time_zone
    Time.zone = browser_time_zone
  end

  private

  def browser_time_zone
    browser_tz = ActiveSupport::TimeZone.find_tzinfo(cookies[:timezone])
    ActiveSupport::TimeZone
      .all
      .find { |zone| zone.tzinfo == browser_tz } || Time.zone
  rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
    Time.zone
  end
end
