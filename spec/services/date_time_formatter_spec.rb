# frozen_string_literal: true

require "rails_helper"

RSpec.describe DateTimeFormatter do
  describe "month_day_time" do
    it "returns the datetime formatted as Saturday, April 4 at 3:31 PM UTC" do
      datetime = Time.parse("2020-04-04 3:31PM UTC")
      formatted_datetime = DateTimeFormatter.month_day_time(datetime)
      expect(formatted_datetime) .to eq "Saturday, April  4 at  3:31 PM UTC"
    end
  end

  describe "month_day" do
    it "returns the datetime formatted as Saturday, April 4" do
      datetime = Time.parse("2020-04-04 3:31PM UTC")
      formatted_datetime = DateTimeFormatter.month_day(datetime)
      expect(formatted_datetime) .to eq "Saturday, April  4"
    end
  end

  describe "time" do
    it "returns the time in 12-hour HH:MM AM/PM format" do
      datetime = Time.parse("2020-04-04 3:31PM UTC")
      formatted_datetime = DateTimeFormatter.time(datetime)
      expect(formatted_datetime).to eq " 3:31 PM"
    end
  end

  describe "time_with_zone" do
    it "returns the time in 12-hour HH:MM AM/PM format with time zone" do
      datetime = Time.parse("2020-04-04 3:31PM UTC")
      formatted_datetime = DateTimeFormatter.time_with_zone(datetime)
      expect(formatted_datetime).to eq " 3:31 PM UTC"
    end
  end

  describe "small_month_day" do
    it "returns abbreviated month plus day of the month" do
      datetime = Time.parse("2020-04-04 3:31PM UTC")
      formatted_datetime = DateTimeFormatter.small_month_day(datetime)
      expect(formatted_datetime).to eq "Apr  4"
    end
  end

  describe "day" do
    it "returns the day of the week" do
      datetime = Time.parse("2020-04-04 3:31PM UTC")
      formatted_datetime = DateTimeFormatter.day(datetime)
      expect(formatted_datetime).to eq "Saturday"
    end
  end

  describe "ecma_datetime" do
    # http://www.ecma-international.org/ecma-262/5.1/#sec-15.9.1.15
    it "returns a datetime formatted according to the ECMAScript spec" do
      datetime = Time.parse("2020-04-04 3:31PM UTC")
      formatted_datetime = DateTimeFormatter.ecma_datetime(datetime)
      expect(formatted_datetime).to eq "2020-04-04T15:31:00.000Z"
    end
  end
end
