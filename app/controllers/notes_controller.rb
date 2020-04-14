# frozen_string_literal: true

class NotesController < ApplicationController
  def create
    @call = Call.find(params[:call_id])
    @note = @call.notes.create(note_params)

    BroadcastNewNoteJob.perform_now(@call, @note) if @note.persisted?
  end

  private

  def note_params
    params.require(:note).permit(:body).merge(author: current_user)
  end
end
