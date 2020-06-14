# frozen_string_literal: true

module Groups
  class GroupInvitesController < ApplicationController
    def index
      @group = Group.find(params[:group_id])
      @group_invites = @group.group_invites
    end

    def create
      group = Group.find(params[:group_id])

      emails.each do |email|
        GroupInviter.perform(email, group, current_user)
      end

      redirect_to group_group_invites_path group
    end

    def destroy
      @group_invite = GroupInvite.find(params[:id])

      @group_invite.destroy
      redirect_to group_group_invites_path @group_invite.group
    end

    private

    def emails
      params[:emails].split(", ").map(&:strip)
    end
  end
end
