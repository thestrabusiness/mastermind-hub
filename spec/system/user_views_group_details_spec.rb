# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User views group details page" do
  it "renders a list of previous calls" do
    user = create(:user, :facilitator)
    group = user.groups.first
    create(:call, group: group, scheduled_on: 14.days.ago)
    create(:call, group: group, scheduled_on: 7.days.ago)

    visit group_path(group, as: user)

    within("#previous_calls") do
      expect(page).to have_selector(".list-item").twice
    end
  end

  context "when there is no call today" do
    context "and there is no upcoming call" do
      it "renders a new call link" do
        user = create(:user, :facilitator)
        group = user.groups.first

        visit group_path(group, as: user)

        expect(page).to have_content "Add a new call"
      end
    end

    context "and there is an upcoming call scheduled" do
      it "renders details for the upcoming call" do
        user = create(:user, :facilitator)
        group = user.groups.first
        create(:call, group: group, scheduled_on: 7.days.from_now)

        visit group_path(group, as: user)

        expect(page).to have_content "Upcoming call"
      end
    end
  end

  context "when there is a call today" do
    it "renders details for today's call" do
      user = create(:user, :facilitator)
      group = user.groups.first
      create(:call, group: group, scheduled_on: Time.current)

      visit group_path(group, as: user)

      expect(page).to have_content "Today\'s call"
    end
  end

  context "without logging in" do
    it "redirects to sign in" do
      group = create(:group)
      visit group_path(group)

      expect(current_path).to eq sign_in_path
    end
  end
end
