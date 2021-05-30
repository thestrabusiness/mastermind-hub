# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :require_login

  def index
    @groups = current_user.groups
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(create_group_params)

    if @group.save
      create_membership
      invite_users
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def show
    @group = current_user.groups.find(params[:id])
    @previous_calls = @group.previous_calls.reorder(scheduled_on: :desc)
  end

  def edit
    @group = current_user.groups.find(params[:id])

    redirect_to groups_path if current_user != @group.creator
  end

  def update
    @group = current_user.groups.find(params[:id])

    if @group.update(group_params)
      redirect_to group_path(@group)
    else
      render :edit
    end
  end

  def destroy
    @group = current_user.groups.find(params[:id])

    @group.destroy if current_user == @group.creator

    redirect_to groups_path
  end

  private

  def create_group_params
    group_params.merge(creator: current_user)
  end

  def group_params
    params.require(:group).permit(:name, :call_day, :call_time)
  end

  def emails
    params.fetch(:emails)&.split(",") || []
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
