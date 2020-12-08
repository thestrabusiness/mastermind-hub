# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommitmentReminderMailer do
  describe ".post_call_reminder" do
    it "properly populates the 'to' field" do
      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first)

      mailer = CommitmentReminderMailer.post_call_reminder(call)

      expect(mailer.to).to eq [user.email]
    end

    it "doesn't send to users who are unsubscribed from reminders" do
      group = create(:group)
      subscribed_user = create(:user, receive_reminder_email: true)
      unsubscribed_user = create(:user, receive_reminder_email: false)
      group.users << [subscribed_user, unsubscribed_user]
      call = create(:call, group: group)

      mailer = CommitmentReminderMailer.post_call_reminder(call)

      expect(mailer.to).to eq [subscribed_user.email]
    end
  end

  describe ".mid_week_reminder" do
    it "properly populates the 'to' field" do
      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first)

      mailer = CommitmentReminderMailer.mid_week_reminder(call)

      expect(mailer.to).to eq [user.email]
    end

    it "doesn't send to users who are unsubscribed from reminders" do
      group = create(:group)
      subscribed_user = create(:user, receive_reminder_email: true)
      unsubscribed_user = create(:user, receive_reminder_email: false)
      group.users << [subscribed_user, unsubscribed_user]
      call = create(:call, group: group)

      mailer = CommitmentReminderMailer.mid_week_reminder(call)

      expect(mailer.to).to eq [subscribed_user.email]
    end
  end
end
