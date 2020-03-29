require 'rails_helper'

RSpec.describe CallPage do
  describe 'viewing_todays_call?' do
    it 'returns true when the call is scheduled today' do
      call = create(:call, scheduled_on: Date.current)
      page = CallPage.new(call, build(:user))

      expect(page.viewing_todays_call?).to be true
    end

    it 'returns false when the call is not scheduled today' do
      call = create(:call, scheduled_on: Date.tomorrow)
      page = CallPage.new(call, build(:user))

      expect(page.viewing_todays_call?).to be false
    end
  end

  describe 'next_call' do
    context 'when there are other calls scheduled after the given call' do
      it 'calls group#next_call' do
        call = create(:call, scheduled_on: Date.current)
        _next_call = create(:call,
                            group: call.group,
                            scheduled_on: Date.tomorrow)
        allow(call.group).to receive :next_call

        page = CallPage.new(call, build(:user))
        page.next_call

        expect(call.group).to have_received :next_call
      end

      it 'does not call group#upcoming_call' do
        call = create(:call, scheduled_on: Date.current)
        _next_call = create(:call,
                            group: call.group,
                            scheduled_on: Date.tomorrow)
        allow(call.group).to receive :upcoming_call

        page = CallPage.new(call, build(:user))
        page.next_call

        expect(call.group).to_not have_received :upcoming_call
      end
    end

    context 'when there are no calls scheduled after the given call' do
      it 'calls group#upcoming_call' do
        call = create(:call, scheduled_on: Date.current)
        create(:call, group: call.group, scheduled_on: Date.tomorrow)
        allow(call.group).to receive :upcoming_call

        page = CallPage.new(call, build(:user))
        page.next_call

        expect(call.group).to_not have_received :upcoming_call
      end
    end
  end
end
