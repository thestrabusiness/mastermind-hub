# frozen_string_literal: true

class UserCommitmentSummary
  attr_reader :user

  def initialize(user, call)
    @user = user
    @call = call
  end

  def previous_commitment_met?
    if previous_commitment.present?
      previous_commitment.completed? ? "Yes" : "No"
    else
      "N/A"
    end
  end

  def previous_weeks_commitment_text
    previous_commitment&.body || no_commitment_text
  end

  def this_weeks_commitment_text
    this_weeks_commitment&.body || no_commitment_text
  end

  private

  attr_reader :call

  def no_commitment_text
    "No commitment made"
  end

  def previous_commitment
    return if call.previous_call.nil?

    call.previous_call.commitments.detect do |commitment|
      commitment.user == user
    end
  end

  def this_weeks_commitment
    call.commitments.detect do |commitment|
      commitment.user == user
    end
  end
end
