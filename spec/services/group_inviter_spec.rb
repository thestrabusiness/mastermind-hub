# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroupInviter do
  it "creates a GroupInvite" do
    user = create(:user, :with_group)
    email = "email@example.com"

    GroupInviter.perform(email, user.groups.first, user)

    expect(GroupInvite.where(email: email).exists?).to be true
  end

  it "sends an invite email" do
    allow(GroupInviteMailer).to receive(:invite).and_call_original
    user = create(:user, :with_group)
    email = "email@example.com"

    GroupInviter.perform(email, user.groups.first, user)

    expect(GroupInviteMailer).to have_received(:invite)
  end

  it "doesn't send an email if the invitee is the inviter" do
    allow(GroupInviteMailer).to receive(:invite).and_call_original
    membership = create(:membership)
    group = membership.group
    user = membership.user

    GroupInviter.perform(user.email, group, user)

    expect(GroupInviteMailer).to_not have_received(:invite)
  end

  it "doesn't create an invite if the invitee is the inviter" do
    membership = create(:membership)
    group = membership.group
    user = membership.user

    GroupInviter.perform(user.email, group, user)

    expect(GroupInvite.where(email: user.email).exists?).to be false
  end
end
