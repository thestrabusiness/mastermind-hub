# frozen_string_literal: true

class CallNotesChannel < ApplicationCable::Channel
  def subscribed
    stream_for call
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def call
    Call.find(params[:call_id])
  end
end
