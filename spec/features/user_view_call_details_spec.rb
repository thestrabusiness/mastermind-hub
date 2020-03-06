require 'rails_helper'

RSpec.feature 'User views call details page' do
  it 'renders last weeks\'s commitments' do
    user = create(:user, :with_group)
    call = create(:call, group: user.groups.first)
    last_weeks_call = create(:call,
                             group: user.groups.first,
                             scheduled_on: 7.days.ago)
    commitment = create(:commitment,
                        call: last_weeks_call,
                        membership: user.memberships.first)

    visit call_path(call, as: user)

    expect(page).to have_content user.full_name
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

    context 'and the user has added a commitment for next week' do
      it 'does not render the commitment form' do
        user = create(:user, :with_group)
        call = create(:call, group: user.groups.first)
        next_call = create(:call,
                           group: user.groups.first,
                           scheduled_on: 7.days.from_now)
        create(:commitment, call: next_call, membership: user.memberships.first)

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

    it 'renders next week\'s commitments' do
      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first)
      next_call = create(:call,
                         group: user.groups.first,
                         scheduled_on: 7.days.from_now)
      commitment = create(:commitment,
                          call: next_call,
                          membership: user.memberships.first)

      visit call_path(call, as: user)

      expect(page).to have_content commitment.body
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
