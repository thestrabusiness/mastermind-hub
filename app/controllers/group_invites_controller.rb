class GroupInvitesController < ApplicationController
  def index
    @group_invites = GroupInvite.unaccepted.where(email: current_user.email)
  end

  def accept
    @group_invite = GroupInvite.find(params[:id])
    AcceptInvite.perform(@group_invite, current_user)
    redirect_to group_invites_path
  end

  def reject
    @group_invite = GroupInvite.find(params[:id])
    @group_invite.destroy
    redirect_to group_invites_path
  end
end
