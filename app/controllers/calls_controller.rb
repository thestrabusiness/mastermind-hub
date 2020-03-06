class CallsController < ApplicationController
  before_action :require_login

  def show
    call = Call.find(params[:id])
    @page = CallPage.new(call)
  end
end
