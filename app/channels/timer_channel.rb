class TimerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "timer_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
