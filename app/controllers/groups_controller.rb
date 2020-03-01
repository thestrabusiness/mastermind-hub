class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      create_membership
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
    params.require(:group).permit(:name).merge(creator: current_user)
  end

  def emails
    params.fetch(:emails)&.split(',') || []
  end

  def create_membership
    @group.memberships.create(user: current_user, role: Membership::FACILITATOR)
  end

  def invite_users
    emails.each do |email|
      GroupInviter.perform(email.strip, @group, current_user)
    end
  end
end
