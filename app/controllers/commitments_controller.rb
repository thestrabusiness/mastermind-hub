class CommitmentsController < ApplicationController
  before_action :require_login

  def create
    @call = Call.find(params[:call_id])
    @commitment = @call.commitments.create(commitment_params)
    redirect_to call_path(@call.group.todays_call)
  end

  private

  def commitment_params
    params
      .require(:commitment)
      .permit(:body)
      .merge(membership: user_membership)
  end

  def user_membership
    current_user.memberships.find_by(group: @call.group)
  end
end
