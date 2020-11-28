# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User edits their profile" do
  context "as a signed in user" do
    it "updates their profile" do
      user = create(:user)
      first_name = "new"
      last_name = "name"
      email = "new@example.com"

      visit edit_user_path(as: user)
      fill_in :user_first_name, with: first_name
      fill_in :user_last_name, with: last_name
      fill_in :user_email, with: email
      click_on "Update User"

      user.reload

      expect(user.first_name).to eq first_name
      expect(user.last_name).to eq last_name
      expect(user.email).to eq email
    end
  end

  context "without an authenticated session" do
    it "redirects to the sign in page" do
      visit edit_user_path

      expect(current_path).to eq sign_in_path
    end
  end
end
