# frozen_string_literal: true

class CommitmentReminderMailer < ApplicationMailer
  def post_call_reminder(call)
    @call = call
    build_commitment_summaries
    mail(to: user_emails,
         subject: "Commitments This Week",
         template_name: "reminder")
  end

  def mid_week_reminder(call)
    @call = call
    build_commitment_summaries
    mail(to: user_emails,
         subject: "How's this week's commitment going?",
         template_name: "reminder")
  end

  private

  def build_commitment_summaries
    @user_commitment_summaries = call_users
      .map { |user| UserCommitmentSummary.new(user, @call) }
  end

  def user_emails
    call_users.map(&:email)
  end

  def call_users
    @call.users.receives_reminders
  end
end
