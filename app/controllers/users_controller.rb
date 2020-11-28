# frozen_string_literal: true

class UsersController < Clearance::UsersController
  before_action :require_login, only: :show

  def show; end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_back_or url_after_create
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
