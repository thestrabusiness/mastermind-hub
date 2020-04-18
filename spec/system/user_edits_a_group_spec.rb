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
