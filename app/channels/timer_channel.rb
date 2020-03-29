# frozen_string_literal: true

class TimerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "call_timer_#{call.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def call
    Call.find(params[:call_id])
  end
end
