require 'rails_helper'

RSpec.describe Group do
  describe 'next call' do
    it 'returns the next call scheduled after the given one' do
      group = create(:group)
      past_call = create(:call, group: group, scheduled_on: 7.days.ago)
      todays_call = create(:call, group: group)
      future_call = create(:call, group: group, scheduled_on: 7.days.from_now)

      expect(group.next_call(past_call)).to eq todays_call
      expect(group.next_call(todays_call)).to eq future_call
      expect(group.next_call(future_call)).to eq nil
    end
  end

  describe 'upcoming_call' do
    context 'when there is a future call scheduled' do
      it 'returns the call' do
        group = create(:group)
        _past_call = create(:call, group: group, scheduled_on: 7.days.ago)
        _todays_call = create(:call, group: group)
        future_call = create(:call, group: group, scheduled_on: 7.days.from_now)

        expect(group.upcoming_call).to eq future_call
      end
    end

    context 'when there is no future call scheduled' do
      it 'creates and returns a new scheduled call' do
        group = create(:group)
        past_call = create(:call, group: group, scheduled_on: 7.days.ago)
        todays_call = create(:call, group: group)

        expect(Call.count).to eq 2

        upcoming_call = group.upcoming_call

        expect(Call.count).to eq 3
        expect(upcoming_call).to_not eq past_call
        expect(upcoming_call).to_not eq todays_call
      end
    end
  end
end
