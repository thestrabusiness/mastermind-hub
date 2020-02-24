class CreateGroupInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :group_invites do |t|
      t.timestamps null: false
      t.string :email, null: false, index: true
      t.string :token, null: false, index: true
      t.boolean :accepted, null: false, default: false
      t.references :group, null: false
    end
  end
end
