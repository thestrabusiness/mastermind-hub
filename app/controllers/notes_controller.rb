# frozen_string_literal: true

class NotesController < ApplicationController
  def create
    @call = Call.find(params[:call_id])
    @note = @call.notes.create(note_params)

    CallNotesChannel.broadcast_to @call, serialized_note if @note.persisted?
  end

  private

  def serialized_note
    {
      body: @note.body,
      author_id: @note.author_id,
      author: current_user.full_name
    }.as_json
  end

  def note_params
    params.require(:note).permit(:body).merge(author: current_user)
  end
end
