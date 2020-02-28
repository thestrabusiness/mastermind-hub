class NotesController < ApplicationController
  def create
    @call = Call.find(params[:call_id])
    @note = @call.notes.create(note_params)

    if @note.persisted?
      CallNotesChannel.broadcast_to @call, serialized_note
    end

    redirect_to @call
  end

  private

  def serialized_note
    { body: @note.body, author: current_user.full_name }.as_json
  end

  def note_params
    params.require(:note).permit(:body).merge(author: current_user)
  end
end
