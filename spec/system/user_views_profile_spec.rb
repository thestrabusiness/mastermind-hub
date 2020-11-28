# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User visits their profile" do
  context "with an authenticated session" do
    it "lists the users details" do
      user = create(:user)

      visit user_path(as: user)

      expect(page).to have_content(user.first_name)
      expect(page).to have_content(user.last_name)
      expect(page).to have_content(user.email)
    end
  end

  context "without an authenticated session" do
    it "redirects to login" do
      visit user_path

      expect(current_path).to eq sign_in_path
    end
  end
end
