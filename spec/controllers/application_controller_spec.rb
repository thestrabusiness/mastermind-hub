# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController do
  controller do
    def test_tz_cookie
      head :ok
    end
  end

  before do
    routes.draw { get "test_tz_cookie" => "anonymous#test_tz_cookie" }
  end

  before do
    allow(Time).to receive(:zone).and_call_original
  end

  after do
    utc = ActiveSupport::TimeZone.all.detect { |tz| tz.name == "UTC" }
    allow(Time).to receive(:zone).and_return(utc)
  end

  it "sets the application's time zone to the browser time zone" do
    cookies[:timezone] = "America/New_York"

    get :test_tz_cookie

    expect(Time.zone.name).to eq "Eastern Time (US & Canada)"
  end
end
