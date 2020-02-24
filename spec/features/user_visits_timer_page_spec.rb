require 'rails_helper'

RSpec.feature 'User visits timer page', js: true do
  context 'When a timer has not been started' do
    it 'displays the no timer message' do
      user = create(:user)
      visit timer_path(as: user)
      expect(page).to have_content 'No timer started yet'
    end
  end

  context 'When a timer has expired' do
    it 'displays the expired message' do
      user = create(:user)
      create(:timer, created_at: 20.minutes.ago)
      visit timer_path(as: user)
      expect(page.has_content?('TIMES UP')).to be true
    end
  end

  context 'When a timer is running' do
    it 'displays the user name' do
      user = create(:user, :with_group)
      timer = create(:timer)
      visit timer_path(as: user)
      expect(page)
        .to have_content "Time left for #{timer.user.first_plus_initial}"
    end
  end

  context "As a 'member'" do
    it 'does not display the new timer form' do
      user = create(:user)
      visit timer_path(as: user)
      expect(page).to_not have_css('.timer-controls')
    end
  end

  context "As a 'facilitator'" do
    it 'displays the new timer form' do
      user = create(:user, :facilitator)
      visit timer_path(as: user)
      expect(page).to have_css('.timer-controls')
    end
  end

  context 'Without being signed in' do
    it 'redirects to the sign in page' do
      visit timer_path
      expect(current_path).to eq sign_in_path
    end
  end
end
