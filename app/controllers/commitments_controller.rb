# frozen_string_literal: true

class CommitmentsController < ApplicationController
  before_action :require_login

  def create
    @call = Call.find(params[:call_id])
    @commitment = @call.commitments.create(create_commitment_params)
    @page = CallPage.new(@call, current_user)
    BroadcastNewCommitmentJob.perform_now(@call, @commitment, current_user)

    respond_to do |format|
      format.js {}
    end
  end

  def edit
    @call = Call.find(params[:call_id])
    @commitment = @call.commitments.find(params[:id])
  end

  def update
    @call = Call.find(params[:call_id])
    @commitment = @call.commitments.find(params[:id])
    @commitment.update(commitment_params)

    respond_to do |format|
      format.js {}
    end
  end

  private

  def create_commitment_params
    commitment_params.merge(membership: user_membership)
  end

  def commitment_params
    params.require(:commitment).permit(:body)
  end

  def user_membership
    current_user.memberships.find_by(group: @call.group)
  end
end
