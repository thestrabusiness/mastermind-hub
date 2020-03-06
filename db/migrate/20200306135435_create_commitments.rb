class CreateCommitments < ActiveRecord::Migration[6.0]
  def change
    create_table :commitments do |t|
      t.timestamps null: false

      t.boolean :completed, default: false, null: false, index: true
      t.string :body, null: false

      t.references :membership, index: true, null: false
      t.references :call, index: true, null: false
      t.index [:membership_id, :call_id], unique: true
    end

    add_column :groups, :call_day, :integer, default: 0, null: false, index: true
    add_column :groups, :call_time, :time, default: '00:00:00', null: false
  end
end
