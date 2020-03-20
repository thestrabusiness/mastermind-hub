class TimersController < ApplicationController
  before_action :require_login
  before_action :load_and_authorize_call
  before_action :check_role, only: :create

  def create
    @call.timers.create(timer_params)
    @page = CallPage.new(@call, current_user)

    ActionCable
      .server
      .broadcast "call_timer_#{@call.id}", { html: render_timer_details }
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

  def render_timer_details
    render(partial: 'calls/timer_details', locals: { page: @page })
  end
end
