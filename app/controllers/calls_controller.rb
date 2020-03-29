# frozen_string_literal: true

class CallsController < ApplicationController
  before_action :require_login
  before_action :load_and_authorize_call

  def show
    call = Call.includes(commitments: :membership).find(params[:id])
    @page = CallPage.new(call, current_user)
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
    @call = Call.find(params[:id])

    redirect_to groups_path unless @call.group.users.includes(current_user)
  end

  def call_params
    params.require(:call).permit(:scheduled_on)
  end
end
