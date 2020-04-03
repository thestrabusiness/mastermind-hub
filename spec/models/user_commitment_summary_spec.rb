# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserCommitmentSummary do
  describe "#previous_commitment_met?" do
    describe "when there is no previous commitment" do
      it "returns N/A" do
        user = create(:user, :with_group)
        call = create(:call, group: user.groups.first)
        user_commitment_summary = UserCommitmentSummary.new(user, call)

        expect(user_commitment_summary.previous_commitment_met?).to eq "N/A"
      end
    end

    describe "when a previous commitment is present" do
      describe "and it is completed" do
        it "returns Yes" do
          user = create(:user, :with_group)
          group = user.groups.first
          call = create(:call, group: group)
          previous_call = create(:call, group: group, scheduled_on: 1.day.ago)
          create(:commitment,
                 :completed,
                 membership: user.memberships.first,
                 call: previous_call)

          user_commitment_summary = UserCommitmentSummary.new(user, call)

          expect(user_commitment_summary.previous_commitment_met?).to eq "Yes"
        end
      end

      describe "and it is incomplete" do
        it "returns No" do
          user = create(:user, :with_group)
          group = user.groups.first
          call = create(:call, group: group)
          previous_call = create(:call, group: group, scheduled_on: 1.day.ago)
          create(:commitment,
                 membership: user.memberships.first,
                 call: previous_call)

          user_commitment_summary = UserCommitmentSummary.new(user, call)

          expect(user_commitment_summary.previous_commitment_met?).to eq "No"
        end
      end
    end
  end

  describe "#previous_weeks_commitment_text" do
    describe "when there is no commitment" do
      it "returns the no commitment text" do
        user = create(:user, :with_group)
        group = user.groups.first
        call = create(:call, group: group)
        _previous_call = create(:call, group: group, scheduled_on: 1.day.ago)

        result = UserCommitmentSummary
          .new(user, call)
          .previous_weeks_commitment_text

        expect(result).to eq "No commitment made"
      end
    end

    describe "when there is a commitment" do
      it "returns the body of the commitment" do
        user = create(:user, :with_group)
        group = user.groups.first
        call = create(:call, group: group)
        previous_call = create(:call, group: group, scheduled_on: 1.day.ago)
        commitment = create(:commitment,
                            membership: user.memberships.first,
                            call: previous_call)

        result = UserCommitmentSummary
          .new(user, call)
          .previous_weeks_commitment_text

        expect(result).to eq commitment.body
      end
    end
  end

  describe "#this_weeks_commitment_text" do
    describe "when there is no commitment" do
      it "returns the no commitment text" do
        user = create(:user, :with_group)
        group = user.groups.first
        call = create(:call, group: group)

        result = UserCommitmentSummary
          .new(user, call)
          .this_weeks_commitment_text

        expect(result).to eq "No commitment made"
      end
    end

    describe "when there is a commitment" do
      it "returns the body of the commitment" do
        user = create(:user, :with_group)
        group = user.groups.first
        call = create(:call, group: group)
        commitment = create(:commitment,
                            membership: user.memberships.first,
                            call: call)

        result = UserCommitmentSummary
          .new(user, call)
          .this_weeks_commitment_text

        expect(result).to eq commitment.body
      end
    end
  end
end
