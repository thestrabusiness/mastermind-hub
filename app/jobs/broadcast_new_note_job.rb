# frozen_string_literal: true

class BroadcastNewNoteJob < ApplicationJob
  def perform(call, note)
    ActionCable.server.broadcast "call_notes:#{call.to_gid_param}",
                                 broadcast_params(note)
  end

  def broadcast_params(note)
    { author_id: note.author_id, html: render_new_note(note) }
  end

  def render_new_note(note)
    ApplicationController
      .render(
        partial: "calls/note",
        locals: { note: note }
      )
  end
end
