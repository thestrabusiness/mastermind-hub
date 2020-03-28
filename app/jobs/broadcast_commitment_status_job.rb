class BroadcastCommitmentStatusJob < ApplicationJob
  def perform(call, commitment, user)
    ActionCable
      .server
      .broadcast "call_commitments_#{call.id}",
                 { updater_id: user.id,
                   commitment_id: commitment.id,
                   html: render_new_icon(commitment) }
  end

  def render_new_icon(commitment)
    ApplicationController
      .render(partial: 'calls/commitment_icon', locals: { commitment: commitment })
  end
end
