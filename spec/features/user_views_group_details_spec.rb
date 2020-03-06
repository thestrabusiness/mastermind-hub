require 'rails_helper'

RSpec.feature 'User views group details page' do
  it 'renders a list of previous calls' do
    user = create(:user, :facilitator)
    group = user.groups.first
    create(:call, group: group, scheduled_on: 14.days.ago)
    create(:call, group: group, scheduled_on: 7.days.ago)

    visit group_path(group, as: user)

    expect(page).to have_selector('.list-item').twice
  end

  context 'when there is no call today' do
    it 'renders details for the upcoming call' do
      user = create(:user, :facilitator)
      group = user.groups.first

      visit group_path(group, as: user)

      expect(page).to have_content 'Upcoming call'
    end
  end

  context 'when there is a call today' do
    it 'renders details for today\'s call' do
      user = create(:user, :facilitator)
      group = user.groups.first
      create(:call, group: group, scheduled_on: Time.current)

      visit group_path(group, as: user)

      expect(page).to have_content "Today\'s call"
    end
  end

  context 'without logging in' do
    it 'redirects to sign in' do
      group = create(:group)
      visit group_path(group)

      expect(current_path).to eq sign_in_path
    end
  end
end
