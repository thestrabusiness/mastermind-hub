# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User creates a commitment", js: true do
  it "adds the commitment to the page" do
    user = create(:user, :with_group)
    call = create(:call, group: user.groups.first)

    visit call_path(call, as: user)
    fill_in "commitment_body", with: "A commitment"

    click_on "Create Commitment"

    expect(page).to have_content("A commitment")
    expect(Commitment.count).to eq 1
  end

  it "doesn't accept an empty body" do
    user = create(:user, :with_group)
    call = create(:call, group: user.groups.first)

    visit call_path(call, as: user)

    click_on "Create Commitment"

    expect(Commitment.count).to eq 0
  end

  context "when it's the first commitment added to a call" do
    it "enqueues the reminder emails" do
      allow(CommitmentReminderMailer)
        .to receive(:post_call_reminder).and_call_original
      allow(CommitmentReminderMailer)
        .to receive(:mid_week_reminder).and_call_original

      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first)

      visit call_path(call, as: user)
      fill_in "commitment_body", with: "A commitment"

      click_on "Create Commitment"

      expect(page).to have_content("A commitment")
      expect(CommitmentReminderMailer).to have_received(:post_call_reminder)
      expect(CommitmentReminderMailer).to have_received(:mid_week_reminder)
    end
  end

  context "when it's not the first commitment added to a call" do
    it "does not enqueue the reminder emails" do
      allow(CommitmentReminderMailer)
        .to receive(:post_call_reminder).and_call_original
      allow(CommitmentReminderMailer)
        .to receive(:mid_week_reminder).and_call_original

      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first)
      create(:commitment,
             call: call,
             membership: create(:membership, group: user.groups.first))

      visit call_path(call, as: user)
      fill_in "commitment_body", with: "A commitment"

      click_on "Create Commitment"

      expect(page).to have_content("A commitment")
      expect(CommitmentReminderMailer).to_not have_received(:post_call_reminder)
      expect(CommitmentReminderMailer).to_not have_received(:mid_week_reminder)
    end
  end
end
