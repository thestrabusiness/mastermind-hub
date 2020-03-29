# frozen_string_literal: true

class AcceptInvite
  def self.perform(invite, user)
    user.groups << invite.group
    invite.update(accepted: true)
  end
end
