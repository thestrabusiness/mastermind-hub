require "rails_helper"

RSpec.describe "User confirms a commitment", js: true do
  context "when the comittment is not completed" do
    it "sets completed to true and updates the icon to a check" do
      membership = create(:membership)
      last_weeks_call = create(:call, group: membership.group, scheduled_on: 7.days.ago)
      call = create(:call, group: membership.group)
      commitment = create(
        :commitment,
        membership: membership,
        call: last_weeks_call,
        completed: false
      )

      visit call_path(call, as: membership.user)
      find(".octicon-x").click

      expect(page).to have_selector(".octicon-check")
      expect(commitment.reload).to be_completed
    end
  end

  context "when the comittment is already completed" do
    it "sets completed to false and updates the icon to an X" do
      membership = create(:membership)
      last_weeks_call = create(:call, group: membership.group, scheduled_on: 7.days.ago)
      call = create(:call, group: membership.group)
      commitment = create(
        :commitment,
        membership: membership,
        call: last_weeks_call,
        completed: true
      )

      visit call_path(call, as: membership.user)
      find(".octicon-check").click

      expect(page).to have_selector(".octicon-x")
      expect(commitment.reload).to_not be_completed
    end
  end
end
