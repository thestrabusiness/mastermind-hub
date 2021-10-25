require "rails_helper"

RSpec.describe "User edits a call" do
  context "as a group member" do
    it "can update the call start time" do
      user = create(:user, :with_group)
      group = user.groups.first
      call = create(:call, group: group, scheduled_on: 1.day.ago)
      updated_date = 5.days.from_now.noon

      visit edit_call_path(call, as: user)
      select updated_date.year.to_s, from: "call_scheduled_on_1i"
      select updated_date.strftime("%B"), from: "call_scheduled_on_2i"
      select updated_date.day.to_s, from: "call_scheduled_on_3i"
      select updated_date.hour.to_s, from: "call_scheduled_on_4i"
      select updated_date.strftime("%M"), from: "call_scheduled_on_5i"
      click_on "Update Call"

      expect(call.reload.scheduled_on).to eq updated_date
    end
  end

  context "as a non-member" do
    it "redirects to the groups list" do
      user = create(:user, :with_group)
      call = create(:call)

      visit edit_call_path(call, as: user)

      expect(page.current_path).to eq groups_path
      expect(page).to_not have_content "Edit call"
    end
  end
end
