class TimersController < ApplicationController
  before_action :require_login

  def show
    @timer = Timer.first
  end
end
