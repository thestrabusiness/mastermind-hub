class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

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

  def group_params
    params.require(:group).permit(:name).merge(facilitator: current_user)
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
