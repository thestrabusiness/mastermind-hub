# frozen_string_literal: true

require "rails_helper"

describe Call do
  describe "previous_call" do
    it "returns the call scheduled immediately before the given call" do
      group = create(:group)
      first_call = create(:call, scheduled_on: 2.weeks.ago, group: group)
      third_call = create(:call, scheduled_on: Time.current, group: group)
      second_call = create(:call, scheduled_on: 1.weeks.ago, group: group)

      expect(first_call.previous_call).to be nil
      expect(second_call.previous_call).to eq first_call
      expect(third_call.previous_call).to eq second_call
    end
  end

  describe "next_call" do
    it "returns the call scheduled immediately after the given call" do
      group = create(:group)
      first_call = create(:call, scheduled_on: 2.weeks.ago, group: group)
      third_call = create(:call, scheduled_on: Time.current, group: group)
      second_call = create(:call, scheduled_on: 1.weeks.ago, group: group)

      expect(first_call.next_call).to eq second_call
      expect(second_call.next_call).to eq third_call
      expect(third_call.next_call).to be nil
    end
  end
end
