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

  it "sets the application's time zone to the browser time zone" do
    cookies[:timezone] = "America/New_York"

    get :test_tz_cookie

    Time.zone.name == "Eastern Time (US & Canada)"
  end
end
