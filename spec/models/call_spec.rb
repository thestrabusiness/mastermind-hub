require 'rails_helper'

describe Call do
  describe 'previous_call' do
    it 'returns the call scheduled before the given call' do
      first_call = create(:call, scheduled_on: 2.weeks.ago)
      second_call = create(:call, scheduled_on: 1.weeks.ago)
      third_call = create(:call, scheduled_on: Time.current)

      expect(first_call.previous_call).to be nil
      expect(second_call.previous_call).to eq first_call
      expect(third_call.previous_call).to eq second_call
    end
  end
end
