# frozen_string_literal: true

class CommitmentConfirmationsController < ApplicationController
  def update
    @call = Call.find(params[:call_id])
    @commitment = @call.commitments.find(params[:commitment_id])
    @commitment.update(completed: !@commitment.completed)
    BroadcastCommitmentStatusJob.perform_now(@call, @commitment, current_user)

    respond_to do |format|
      format.js {}
    end
  end
end
