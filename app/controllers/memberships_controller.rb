class MembershipsController < ApplicationController
  def destroy
    membership = Membership.find(params[:id])

    unless current_user == membership.user
      membership.destroy
    end

    redirect_to edit_group_path membership.group
  end
end
