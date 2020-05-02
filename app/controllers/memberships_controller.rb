# frozen_string_literal: true

class MembershipsController < ApplicationController
  def destroy
    membership = Membership.find(params[:id])
    membership.destroy unless current_user == membership.user
    redirect_to edit_group_path membership.group
  end
end
