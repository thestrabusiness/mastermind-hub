require 'rails_helper'

RSpec.describe GroupInviteMailer do
  it 'sends an email that contains an invite link' do
    invite = build(:group_invite)
    user = build(:user)
    mail = GroupInviteMailer.invite(invite, user)

    expect(mail.to).to include invite.email
    expect(mail.body.encoded).to include invite.token
  end
end
