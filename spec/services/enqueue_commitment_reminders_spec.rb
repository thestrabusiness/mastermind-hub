# frozen_string_literal: true

require "rails_helper"

RSpec.describe EnqueueCommitmentReminders do
  describe "perform" do
    context "when a call has a single commitment" do
      it "enqueues the reminder emails" do
        allow(CommitmentReminderMailer)
          .to receive(:post_call_reminder).and_call_original
        allow(CommitmentReminderMailer)
          .to receive(:mid_week_reminder).and_call_original

        call = create(:call)
        create(:commitment,
               call: call,
               membership: create(:membership, group: call.group))

        EnqueueCommitmentReminders.perform(call)

        expect(CommitmentReminderMailer).to have_received(:post_call_reminder)
        expect(CommitmentReminderMailer).to have_received(:mid_week_reminder)
      end
    end

    context "when the call already has a commitment" do
      it "does not enqueue the reminder emails" do
        allow(CommitmentReminderMailer)
          .to receive(:post_call_reminder).and_call_original
        allow(CommitmentReminderMailer)
          .to receive(:mid_week_reminder).and_call_original

        call = create(:call)
        create(:commitment,
               call: call,
               membership: create(:membership, group: call.group))
        create(:commitment,
               call: call,
               membership: create(:membership, group: call.group))

        EnqueueCommitmentReminders.perform(call)

        expect(CommitmentReminderMailer).to_not have_received(:post_call_reminder)
        expect(CommitmentReminderMailer).to_not have_received(:mid_week_reminder)
      end
    end
  end
end
