class GroupInviteMailer < ApplicationMailer
  def invite(invite, user)
    @invite = invite
    @user = user

    mail(to: @invite.email, subject: "You've been invited to MastermindHub")
  end
end
