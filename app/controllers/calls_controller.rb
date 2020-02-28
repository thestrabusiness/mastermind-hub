class CallsController < ApplicationController
  def show
    @call = Call.find(params[:id])
  end
end
