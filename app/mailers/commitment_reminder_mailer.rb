# frozen_string_literal: true

class CommitmentReminderMailer < ApplicationMailer
  def post_call_reminder(call)
    @call = call
    build_commitment_summaries
    mail(to: recipients,
         subject: "Commitments This Week",
         template_name: "reminder")
  end

  def mid_week_reminder(call)
    @call = call
    build_commitment_summaries
    mail(to: recipients,
         subject: "How's this week's commitment going?",
         template_name: "reminder")
  end

  private

  def build_commitment_summaries
    @user_commitment_summaries = @call
      .users
      .map { |user| UserCommitmentSummary.new(user, @call) }
  end

  def recipients
    @call.users.map(&:email)
  end
end
