# frozen_string_literal: true

require "rails_helper"

describe Membership do
  describe "validations" do
    it "should validate that a user cannot have duplicate memberships" do
      first_membership = create(:membership)
      user = first_membership.user
      group = first_membership.group

      second_membership = user.memberships.create(group: group)

      expect(second_membership).to_not be_valid
    end
  end
end
