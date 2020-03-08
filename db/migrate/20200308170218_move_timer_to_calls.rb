class MoveTimerToCalls < ActiveRecord::Migration[6.0]
  def change
    Timer.destroy_all
    remove_reference :timers, :group, index: true, null: false
    add_reference :timers, :call, index: true, null: false
  end
end
