class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.timestamps null: false
      t.references :call, index: true, null: false
      t.string :body, null: false
      t.references :author, index: true, null: false
    end

    remove_column :calls, :notes, :string
  end
end
