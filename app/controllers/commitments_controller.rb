# frozen_string_literal: true

class CommitmentsController < ApplicationController
  before_action :require_login
  before_action :set_call
  before_action :set_commitment, except: :create

  def create
    @commitment = @call.commitments.create(create_commitment_params)
    @page = CallPage.new(@call, current_user)

    if @commitment.persisted?
      BroadcastNewCommitmentJob.perform_now(@call, @commitment, current_user)
      EnqueueCommitmentReminders.perform(@call) if @call.todays_call?
    end

    respond_to do |format|
      format.js do
        if @commitment.persisted?
          render "create"
        else
          head :bad_request
        end
      end
    end
  end

  def edit; end

  def update
    @commitment.update(commitment_params)

    respond_to do |format|
      format.js {}
    end
  end

  private

  def set_call
    @call = Call.find(params[:call_id])
  end

  def set_commitment
    @commitment = @call.commitments.find(params[:id])
  end

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
