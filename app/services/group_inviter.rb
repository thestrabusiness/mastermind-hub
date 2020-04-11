# frozen_string_literal: true

class GroupInviter
  def self.perform(email, group, user)
    invite = GroupInvite.create(email: email, group: group)
    if invite.valid?
      GroupInviteMailer.invite(invite, user).deliver_now
    end
  end
end
