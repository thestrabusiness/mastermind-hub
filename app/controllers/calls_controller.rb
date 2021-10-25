# frozen_string_literal: true

class CallsController < ApplicationController
  before_action :require_login
  before_action :load_and_authorize_call, except: [:new, :create]

  def show
    call = Call.includes(commitments: :membership).find(params[:id])
    @page = CallPage.new(call, current_user)
  end

  def new
    @group = Group.find(params[:group_id])
    @call = Call.new(scheduled_on: @group.next_call_date)
  end

  def create
    @group = Group.find(params[:group_id])
    @call = Call.new(call_params.merge(group: @group))

    if @call.save
      redirect_to call_path(@call)
    else
      render :new
    end
  end

  def update
    if @call.update(call_params)
      redirect_to call_path(@call)
    else
      render :edit
    end
  end

  private

  def load_and_authorize_call
    action = action_name.to_sym
    if [:show, :update, :edit].include? action
      @call = Call.find(params[:id])
      redirect_to groups_path unless @call.group.users.include?(current_user)
    end

    if [:new, :create].include? action
      redirect_to groups_path unless @group.users.include?(current_user)
    end
  end

  def call_params
    params.require(:call).permit(:scheduled_on)
  end
end
