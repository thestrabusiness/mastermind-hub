class CreateCalls < ActiveRecord::Migration[6.0]
  def change
    create_table :calls do |t|
      t.timestamps null: false
      t.datetime :scheduled_on, index: true, null: false
      t.references :group, index: true, null: false
      t.string :notes
    end
  end
end
