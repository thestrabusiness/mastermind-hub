class TimersController < ApplicationController
  before_action :require_login
  before_action :load_and_authorize_group
  before_action :check_role, only: :create

  def show
    @timer = @group.timers.last
  end

  def create
    @timer = @group.timers.create(timer_create_params)

    if @timer.persisted?
      ActionCable.server.broadcast 'timer_channel', @timer.as_json
    end

    render :show
  end

  private

  def load_and_authorize_group
    @group = Group.find(params[:group_id])

    if !current_user.groups.includes(@group)
      redirect_to groups_path
    end
  end

  def check_role
    if !current_user.facilitator?
      redirect_to timer_path
    end
  end

  def timer_params
    params.require(:timer).permit(:duration, :user_id)
  end

  def timer_create_params
    timer_params.merge(group: current_user.groups.first)
  end
end
