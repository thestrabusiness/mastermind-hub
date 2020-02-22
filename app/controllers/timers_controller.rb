class TimersController < ApplicationController
  before_action :require_login
  before_action :check_role, only: :create

  def show
    @timer = Timer.last
  end

  def create
    @timer = Timer.create(timer_params.merge(facilitator: current_user))

    if @timer.persisted?
      ActionCable.server.broadcast 'timer_channel', @timer.as_json
    end

    render :show
  end

  private 

  def check_role
    if !current_user.facilitator?
      redirect_to timer_path
    end
  end

  def timer_params
    params.require(:timer).permit(:user_id)
  end
end
