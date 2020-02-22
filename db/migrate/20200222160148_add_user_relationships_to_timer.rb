class AddUserRelationshipsToTimer < ActiveRecord::Migration[6.0]
  def change
    add_reference :timers, :facilitator, index: true, null: false
    add_reference :timers, :user, null: false
  end
end
