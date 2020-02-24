class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.timestamps null: false
      t.references :facilitator, index: true, null: false
      t.string :name, null: false
    end

    create_table :groups_users do |t|
      t.references :group, index: true, null: false
      t.references :user, index: true, null: false
      t.index [:group_id, :user_id], unique: true
    end

    remove_reference :timers, :facilitator, index: true, null: false
    add_reference :timers, :group, index: true, null: false
  end
end
