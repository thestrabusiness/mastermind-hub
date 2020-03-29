# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User creates a group", js: true do
  it "Creates a group and shows its details" do
    user = create(:user)
    group_name = "New Group"
    visit new_group_path(as: user)

    fill_in "Name", with: group_name
    click_on "Create Group"

    group = Group.first

    expect(current_path).to eq group_path(group)
    expect(page).to have_content user.full_name
    expect(page).to have_content group_name
  end

  it "assigns them as the facilitator" do
    user = create(:user)
    group_name = "New Group"
    visit new_group_path(as: user)

    fill_in "Name", with: group_name
    click_on "Create Group"

    group = Group.first
    expect(group.facilitator).to eq user
  end

  it "calls GroupInviter once for each email" do
    allow(GroupInviter).to receive(:perform)

    user = create(:user)
    group_name = "New Group"
    email1 = "email1@example.com"
    email2 = "email2@example.com"
    visit new_group_path(as: user)

    fill_in "Name", with: group_name
    fill_in "Emails", with: [email1, email2].join(",")
    click_on "Create Group"

    expect(GroupInviter).to have_received(:perform).twice
  end

  it "creates a group invite for each user listed" do
    user = create(:user)
    group_name = "New Group"
    email1 = "email1@example.com"
    email2 = "email2@example.com"
    visit new_group_path(as: user)

    fill_in "Name", with: group_name
    fill_in "Emails", with: [email1, email2].join(",")
    click_on "Create Group"

    expect(GroupInvite.where(email: email1).exists?).to be true
    expect(GroupInvite.where(email: email2).exists?).to be true
  end
end
