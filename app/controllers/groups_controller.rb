class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(create_group_params)

    if @group.save
      invite_users
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  private

  def create_group_params
    group_params.merge(facilitator: current_user, user_ids: [current_user.id])
  end

  def group_params
    params.require(:group).permit(:name)
  end

  def emails
    params.fetch(:emails)&.strip&.split(',') || []
  end

  def invite_users
    emails.each do |email|
      GroupInviter.perform(email, @group, current_user)
    end
  end
end
