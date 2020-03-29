require 'rails_helper'

RSpec.describe Group do
  describe 'next call' do
    it 'returns the next call scheduled after the given one' do
      group = create(:group)
      future_call = create(:call, group: group, scheduled_on: 7.days.from_now)
      past_call = create(:call, group: group, scheduled_on: 7.days.ago)
      todays_call = create(:call, group: group)

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
      context 'and today is a call day' do
        it 'creates a call scheduled 7 days from today' do
          group = create(:group, call_day: Date.current.wday)
          past_call = create(:call, group: group, scheduled_on: 7.days.ago)
          todays_call = create(:call, group: group)
          expected_next_call_date = todays_call.scheduled_on + 7.days

          expect(Call.count).to eq 2

          upcoming_call = group.upcoming_call

          expect(Call.count).to eq 3
          expect(upcoming_call).to_not eq past_call
          expect(upcoming_call).to_not eq todays_call
          expect(upcoming_call.scheduled_on.strftime('%A %e'))
            .to eq expected_next_call_date.strftime('%A %e')
        end
      end

      context 'and today is not a call day' do
        it 'creates a call scheduled 7 days after the most recent call' do
          call_day = Array(0..6).reject { |day| day == Date.current.wday }.sample
          group = create(:group, call_day: call_day)
          past_call = create(
            :call,
            group: group,
            scheduled_on: Chronic.parse("last #{group.call_day}")
          )

          expected_next_call_date = past_call.scheduled_on + 7.days

          expect(Call.count).to eq 1

          upcoming_call = group.upcoming_call

          expect(Call.count).to eq 2
          expect(upcoming_call).to_not eq past_call
          expect(upcoming_call.scheduled_on.strftime('%A %e'))
            .to eq expected_next_call_date.strftime('%A %e')
        end
      end
    end
  end
end
