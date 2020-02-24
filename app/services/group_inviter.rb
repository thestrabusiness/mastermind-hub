class GroupInviter
  def self.perform(email, group, user)
    invite = GroupInvite.create(email: email, group: group)
    GroupInviteMailer.invite(invite, user).deliver_now
  end
end
