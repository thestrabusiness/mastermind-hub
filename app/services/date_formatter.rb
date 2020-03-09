class DateFormatter
  def self.month_day_time(datetime)
    datetime.strftime('%A, %B %e at %l %p %Z')
  end

  def self.month_day(datetime)
    datetime.strftime('%A, %B %e')
  end

  def self.time_with_zone(datetime)
    datetime.strftime('%l:%m %p %Z')
  end

  def self.time(datetime)
    datetime.strftime('%l:%m %p')
  end

  def self.small_month_day(datetime)
    datetime.strftime('%b %e')
  end

  def self.day(datetime)
    datetime.strftime('%A')
  end
end
