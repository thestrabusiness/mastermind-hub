class CommitmentsController < ApplicationController
  before_action :require_login

  def create
    @call = Call.find(params[:call_id])
    @call.commitments.create(create_commitment_params)

    redirect_to call_path(@call.group.todays_call)
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
      format.html { redirect_to call_path(@call.group.todays_call) }
    end
  end

  private

  def create_commitment_params
    commitment_params.merge(membership: user_membership)
  end

  def commitment_params
    params.require(:commitment).permit(:body, :completed)
  end

  def user_membership
    current_user.memberships.find_by(group: @call.group)
  end
end
