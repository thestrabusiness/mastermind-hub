# frozen_string_literal: true

require "rails_helper"

RSpec.describe Commitment do
  describe "validations" do
    it "validates that the membership is for the associated call's group" do
      call = create(:call)
      valid_group = call.group
      valid_membership = create(:membership, group: valid_group)
      invalid_membership = create(:membership)

      valid_commitment = build(:commitment,
                               call: call,
                               membership: valid_membership)
      invalid_commitment = build(:commitment,
                                 call: call,
                                 membership: invalid_membership)

      expect(valid_commitment).to be_valid
      expect(invalid_commitment).to_not be_valid
    end
  end
end
