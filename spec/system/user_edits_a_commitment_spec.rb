# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User edits a commitment", js: true do
  it "does not alert the user when editing a commitment for today's call" do
    membership = create(:membership)
    call = create(:call, group: membership.group)
    commitment = create(:commitment,
                        call: call,
                        membership: membership,
                        body: "A commitment")

    visit call_path(call, as: membership.user)
    click_on dom_id(commitment, "pencil")

    expect { page.driver.browser.switch_to.alert }
      .to raise_exception Selenium::WebDriver::Error::NoSuchAlertError
  end

  it "alerts the user when editing a commitment for a past call" do
    membership = create(:membership)
    call = create(:call, group: membership.group)
    past_call = create(:call, group: membership.group, scheduled_on: 1.day.ago)
    commitment = create(:commitment,
                        call: past_call,
                        membership: membership,
                        body: "A commitment")

    visit call_path(call, as: membership.user)
    click_on dom_id(commitment, "pencil")

    alert_text = page.driver.browser.switch_to.alert.text

    expect(alert_text).to_not be_empty
  end

  it "reveals the inline form when the user clicks the pencil icon" do
    membership = create(:membership)
    call = create(:call, group: membership.group)
    commitment = create(:commitment,
                        call: call,
                        membership: membership,
                        body: "A commitment")

    visit call_path(call, as: membership.user)
    click_on dom_id(commitment, "pencil")

    expect(page).to have_selector("##{dom_id(commitment, 'inline_form')}")
  end

  it "updates the commitment body" do
    membership = create(:membership)
    call = create(:call, group: membership.group)
    commitment = create(:commitment,
                        call: call,
                        membership: membership,
                        body: "A commitment")

    visit call_path(call, as: membership.user)
    click_on dom_id(commitment, "pencil")
    fill_in "commitment_body", with: "A new commitment"
    click_on "Done"

    expect(page).to have_content "A new commitment"
  end
end
