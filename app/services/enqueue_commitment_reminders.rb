# frozen_string_literal: true

class EnqueueCommitmentReminders
  def self.perform(call)
    return unless call.commitments.count == 1

    CommitmentReminderMailer
      .post_call_reminder(call)
      .deliver_later(wait: 2.hours)

    CommitmentReminderMailer
      .mid_week_reminder(call)
      .deliver_later(wait: 3.5.days)
  end
end
