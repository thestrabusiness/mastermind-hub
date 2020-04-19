# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User manages group invites" do
  it "views outstanding group invites" do
    user = create(:user, :with_group)
    group = user.groups.first
    group_invites = create_list(:group_invite, 3, group: group)

    visit group_group_invites_path(group, as: user)

    group_invites.each do |invite|
      expect(page).to have_content invite.email
    end
  end

  it "retracts outstanding group invites" do
    user = create(:user, :with_group)
    group = user.groups.first
    invite = create(:group_invite, group: group)

    visit group_group_invites_path(group, as: user)
    click_on "Retract"

    expect(page.current_path).to eq group_group_invites_path(group)
    expect(page).to_not have_content(invite)
  end

  it "creates new invites" do
    user = create(:user, :with_group)
    group = user.groups.first

    email1 = "newuser@example.com"
    email2 = "anotheruser@example.com"

    visit group_group_invites_path(group, as: user)
    fill_in "emails", with: "#{email1}, #{email2}"
    click_on "Send Invites"

    expect(page.current_path).to eq group_group_invites_path(group)
    expect(GroupInvite.count).to eq 2
    expect(page).to have_content email1
    expect(page).to have_content email2
  end

  it "sends emails to new invitees" do
    user = create(:user, :with_group)
    group = user.groups.first

    email1 = "newuser@example.com"
    email2 = "anotheruser@example.com"

    visit group_group_invites_path(group, as: user)
    fill_in "emails", with: "#{email1}, #{email2}"
    expect { click_on "Send Invites" }
      .to change { ActionMailer::Base.deliveries.count }.by 2
  end
end
