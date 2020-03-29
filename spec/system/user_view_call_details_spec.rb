require 'rails_helper'

RSpec.describe 'User views call details page', js: true do
  it 'renders the previous weeks\'s commitments' do
    user = create(:user, :with_group)
    call = create(:call, group: user.groups.first)
    previous_weeks_call = create(:call,
                                 group: user.groups.first,
                                 scheduled_on: 7.days.ago)
    commitment = create(:commitment,
                        call: previous_weeks_call,
                        membership: user.memberships.first)

    visit call_path(call, as: user)

    expect(page).to have_content user.first_name
    expect(page).to have_content commitment.body
  end

  it 'renders a no previous commitments message' do
    user = create(:user, :with_group)
    call = create(:call, group: user.groups.first)
    create(:call, group: user.groups.first, scheduled_on: 7.days.ago)

    visit call_path(call, as: user)

    expect(page).to have_content 'There were no commitments for the last call'
  end

  context 'when the call is not today\'s call' do
    it 'does not render the commitment form' do
      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first, scheduled_on: 7.days.ago)

      visit call_path(call, as: user)

      expect(page).to_not have_selector('#commitment_form')
    end

    it 'renders the appropriate title' do
      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first, scheduled_on: 7.days.ago)

      visit call_path(call, as: user)

      expect(page).to have_content 'Call on:'
    end
  end

  context 'when the call is today\'s call' do
    context 'and the user has not yet added a commitment' do
      it 'renders the commitment form' do
        user = create(:user, :with_group)
        call = create(:call, group: user.groups.first)

        visit call_path(call, as: user)

        expect(page).to have_selector('#commitment_form')
      end
    end

    context 'and the user has added a commitment for this week' do
      it 'does not render the commitment form' do
        user = create(:user, :with_group)
        call = create(:call, group: user.groups.first)
        create(:commitment, call: call, membership: user.memberships.first)

        visit call_path(call, as: user)

        expect(page).to_not have_selector('#commitment_form')
      end
    end

    it 'renders the appropriate title' do
      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first)

      visit call_path(call, as: user)

      expect(page).to have_content "Today's Call"
    end

    it 'renders this week\'s commitments' do
      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first)
      commitment = create(:commitment,
                          call: call,
                          membership: user.memberships.first)

      visit call_path(call, as: user)

      expect(page).to have_content commitment.body
    end
  end

  context 'When a timer has not been started' do
    it 'displays the no timer message' do
      call = create(:call)
      user = create(:user, group_ids: [call.group_id])

      visit call_path(call, as: user)

      within(".timer-details") do
        expect(page).to have_content 'No timer started yet'
      end
    end
  end

  context 'When a timer has expired' do
    it 'displays the expired message' do
      timer = create(:timer, created_at: 20.minutes.ago)
      user = create(:user, group_ids: [timer.call.group_id])

      visit call_path(timer.call, as: user)

      within(".timer-details") do
        expect(page.has_content?('TIMES UP')).to be true
      end
    end
  end

  context 'When a timer is running' do
    it 'displays the user name' do
      timer = create(:timer)
      user = create(:user, group_ids: [timer.call.group_id])

      visit call_path(timer.call, as: user)

      within(".timer-details") do
        expect(page).to have_content timer.user.first_plus_initial
      end
    end
  end

  context "As a 'member'" do
    it 'does not display the new timer form' do
      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first)

      visit call_path(call, as: user)

      expect(page).to_not have_css('.timer-controls')
    end
  end

  context 'as a facilitator' do
    it 'displays the new timer form' do
      user = create(:user, :facilitator)
      call = create(:call, group: user.groups.first)

      visit call_path(call, as: user)

      expect(page).to have_css('.timer-controls')
    end

    it 'creates a timer' do
      user = create(:user, :facilitator)
      call = create(:call, group: user.groups.first)

      visit call_path(call, as: user)
      select 15, from: :timer_duration
      select user.full_name, from: :timer_user_id
      click_on 'Create Timer'

      within(".timer-details") do
        expect(page).to have_content user.first_plus_initial
      end
    end
  end

  context 'without logging in' do
    it 'redirects to sign in' do
      call = create(:call)
      visit call_path(call)

      expect(current_path).to eq sign_in_path
    end
  end
end
