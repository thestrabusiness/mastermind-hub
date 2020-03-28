class BroadcastNewCommitmentJob < ApplicationJob
  def perform(call, commitment, author)
    ActionCable
      .server
      .broadcast "call_commitments_#{call.id}",
                 { author_id: author.id,
                   html: render_new_commitment(commitment) }
  end

  def render_new_commitment(commitment)
    ApplicationController
      .render(
        partial: 'calls/commitment',
        locals: { commitment: commitment, show_completed: false, viewer: nil }
      )
  end
end
