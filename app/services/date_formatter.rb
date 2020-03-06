class DateFormatter
  def self.month_day_time(datetime)
    datetime.strftime('%A, %B %e at %l %p %Z')
  end
end
