# frozen_string_literal: true

require "rails_helper"

RSpec.describe Group do
  describe "validations" do
    subject { build(:group) }

    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :name }
    it { should validate_presence_of :call_time }
    it { should validate_presence_of :call_day }
  end

  describe "next call" do
    it "returns the next call scheduled after the given one" do
      group = create(:group)
      future_call = create(:call, group: group, scheduled_on: 7.days.from_now)
      past_call = create(:call, group: group, scheduled_on: 7.days.ago)
      todays_call = create(:call, group: group)

      expect(group.next_call(past_call)).to eq todays_call
      expect(group.next_call(todays_call)).to eq future_call
      expect(group.next_call(future_call)).to eq nil
    end
  end
end
