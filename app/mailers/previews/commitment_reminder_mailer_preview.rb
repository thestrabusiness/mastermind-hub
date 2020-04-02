# frozen_string_literal: true

class CommitmentReminderMailerPreview < ActionMailer::Preview
  def post_call_reminder
    CommitmentReminderMailer.post_call_reminder(Call.last)
  end

  def mid_week_reminder
    CommitmentReminderMailer.mid_week_reminder(Call.last)
  end
end
