class CallsController < ApplicationController
  before_action :require_login

  def show
    call = Call.includes(commitments: :membership).find(params[:id])
    @page = CallPage.new(call, current_user)
  end
end
