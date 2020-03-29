# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User views group invites page" do
  it "lists unaccepted group invites sent to the user's email" do
    user = create(:user)
    invites = create_list(:group_invite, 3, email: user.email)
    accepted_invite = create(:group_invite, email: user.email, accepted: true)

    visit group_invites_path(as: user)

    expect(page).to have_content invites[0].group.name
    expect(page).to have_content invites[1].group.name
    expect(page).to have_content invites[2].group.name
    expect(page).to_not have_content accepted_invite.group.name
  end

  context "accepts the invite" do
    it "removes the invite from the list and adds the user to the group" do
      user = create(:user)
      invite = create(:group_invite, email: user.email)

      visit group_invites_path(as: user)

      click_on "Accept"

      expect(current_path).to eq group_invites_path
      expect(page).to_not have_content invite.group.name
      expect(user.reload.groups).to include invite.group
    end
  end

  context "rejects the invite" do
    it "removes the invite from the list" do
      user = create(:user)
      invite = create(:group_invite, email: user.email)

      visit group_invites_path(as: user)

      click_on "Reject"

      expect(current_path).to eq group_invites_path
      expect(page).to_not have_content invite.group.name
    end
  end
end
