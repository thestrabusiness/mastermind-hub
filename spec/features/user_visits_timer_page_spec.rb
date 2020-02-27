require 'rails_helper'

RSpec.feature 'User visits timer page', js: true do
  context 'When a timer has not been started' do
    it 'displays the no timer message' do
      group = create(:group)
      user = create(:user, group_ids: [group.id])

      visit group_timer_path(group, as: user)

      expect(page).to have_content 'No timer started yet'
    end
  end

  context 'When a timer has expired' do
    it 'displays the expired message' do
      timer = create(:timer, created_at: 20.minutes.ago)
      user = create(:user, group_ids: [timer.group.id])

      visit group_timer_path(timer.group, as: user)

      expect(page.has_content?('TIMES UP')).to be true
    end
  end

  context 'When a timer is running' do
    it 'displays the user name' do
      timer = create(:timer)
      user = create(:user, group_ids: [timer.group.id])

      visit group_timer_path(timer.group, as: user)

      expect(page)
        .to have_content "Time left for #{timer.user.first_plus_initial}"
    end
  end

  context "As a 'member'" do
    it 'does not display the new timer form' do
      user = create(:user, :with_group)

      visit group_timer_path(user.groups.first, as: user)

      expect(page).to_not have_css('.timer-controls')
    end
  end

  context "As a 'facilitator'" do
    it 'displays the new timer form' do
      user = create(:user, :facilitator, :with_group)

      visit group_timer_path(user.groups.first, as: user)

      expect(page).to have_css('.timer-controls')
    end
  end

  context 'Without being signed in' do
    it 'redirects to the sign in page' do
      group = create(:group)
      visit group_timer_path(group)
      expect(current_path).to eq sign_in_path
    end
  end
end
