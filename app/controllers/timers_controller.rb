class TimersController < ApplicationController
  def show
    @timer = Timer.first
  end
end
