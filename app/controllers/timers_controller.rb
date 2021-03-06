# frozen_string_literal: true

class TimersController < ApplicationController
  before_action :require_login
  before_action :load_and_authorize_call
  before_action :check_role, only: :create

  def create
    @call.timers.create(timer_params)
    @page = CallPage.new(@call, current_user)
    BroadcastNewTimerJob.perform_now(@page)
    redirect_to @call
  end

  private

  def load_and_authorize_call
    @call = Call.find(params[:call_id])

    redirect_to groups_path unless current_user.in_group?(@call.group)
  end

  def check_role
    redirect_to call_path(@call) if @call.group.facilitator != current_user
  end

  def timer_params
    params.require(:timer).permit(:duration, :user_id)
  end
end
