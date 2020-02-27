require 'rails_helper'

RSpec.describe GroupInviteMailer do
  it 'sends an email that contains an invite link' do
    invite = build(:group_invite)
    user = build(:user)
    mail = GroupInviteMailer.invite(invite, user)

    expect(mail.to).to include invite.email
    expect(mail.body.encoded).to include invite.group.name
    expect(mail.body.encoded).to include sign_up_url
    expect(mail.body.encoded).to include sign_in_url
  end
end
