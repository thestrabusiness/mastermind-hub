class TimersController < ApplicationController
  before_action :require_login
  before_action :load_and_authorize_call
  before_action :check_role, only: :create

  def create
    @timer = @call.timers.create(timer_params)

    if @timer.persisted?
      ActionCable.server.broadcast 'timer_channel', @timer.as_json
    end

    redirect_to call_path(@call)
  end

  private

  def load_and_authorize_call
    @call = Call.find(params[:call_id])

    if !current_user.in_group?(@call.group)
      redirect_to groups_path
    end
  end

  def check_role
    if @call.group.facilitator != current_user
      redirect_to call_path(@call)
    end
  end

  def timer_params
    params.require(:timer).permit(:duration, :user_id)
  end
end
