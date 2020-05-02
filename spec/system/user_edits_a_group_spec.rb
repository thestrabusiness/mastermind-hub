# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User visits edit group page" do
  context "as the group owner" do
    it "doesn't see the emails field" do
      user = create(:user, :with_group)
      group = user.groups.first

      visit edit_group_path(group, as: user)

      expect(page).to_not have_selector "#emails"
    end

    context "clicks the trashcan link" do
      it "removes the group from their list" do
        user = create(:user, :with_group)
        group = user.groups.first

        visit edit_group_path(group, as: user)
        click_on :delete_group

        expect(page.current_path).to eq groups_path
        expect(page).to_not have_content group.name
      end

      it "deletes all dependent objects" do
        user = create(:user, :with_group)
        group = user.groups.first
        membership = create(:membership, group: group)
        call = create(:call, group: group)
        _group_invite = create(:group_invite, group: group)
        _timer = create(:timer, call: call)
        _commitment = create(:commitment, membership: membership, call: call)

        visit edit_group_path(group, as: user)
        click_on :delete_group

        expect(GroupInvite.count).to be_zero
        expect(Call.count).to be_zero
        expect(Membership.count).to be_zero
        expect(Commitment.count).to be_zero
        expect(Timer.count).to be_zero
      end
    end

    it "lists the existing members" do
      user = create(:user, :with_group)
      group = user.groups.first
      member = create(
        :membership,
        group: group,
        user: create(:user)
      )
      other_member = create(
        :membership,
        group: group,
        user: create(:user)
      )

      visit edit_group_path(group, as: user)

      expect(page).to have_content user.full_name
      expect(page).to have_content member.user.full_name
      expect(page).to have_content other_member.user.full_name
    end

    it "removes a member from the group" do
      user = create(:user, :with_group)
      group = user.groups.first
      member = create(
        :membership,
        group: group,
        user: create(:user, first_name: "delete")
      )
      other_member = create(
        :membership,
        group: group,
        user: create(:user, first_name: "keep")
      )

      visit edit_group_path(group, as: user)

      within "#group_members" do
        click_on :"delete_member_#{member.id}"
      end

      expect(page).to_not have_content member.user.full_name
      expect(page).to have_content other_member.user.full_name
    end

    it "prevents a user from deleting their own membership" do
      membership = create(:membership)

      delete group_membership_path(
        membership.group,
        membership,
        as: membership.user
      )

      expect(Membership.find(membership.id)).to be_present
    end
  end

  context "when the user is not the group owner" do
    it "redirect user back to groups index" do
      user = create(:user)
      group = create(:group)
      group.users << user

      visit edit_group_path(group, as: user)

      expect(page.current_path).to eq groups_path
    end
  end
end
