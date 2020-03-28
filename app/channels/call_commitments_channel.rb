class CallCommitmentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "call_commitments_#{call.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def call
    Call.find(params[:call_id])
  end
end
