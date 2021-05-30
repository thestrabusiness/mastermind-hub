# frozen_string_literal: true

require "rails_helper"

describe GroupInvite do
  describe "validations" do
    it "should validate the invitee is not already a member" do
      membership = create(:membership)
      user = membership.user
      group = membership.group
      invite = build(:group_invite, group: group, email: user.email)

      expect(invite).to_not be_valid
    end
  end
end
