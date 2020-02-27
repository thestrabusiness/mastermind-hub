class ChangeGroupMembershipRelationships < ActiveRecord::Migration[6.0]
  def change
    drop_table :groups_users
    create_table :memberships do |t|
      t.references :user, index: true, null: false
      t.references :group, index: true, null: false
      t.string :role, null: false, default: Membership::MEMBER
      t.index [:group_id, :user_id]
    end
    remove_reference :groups, :facilitator
    add_reference :groups, :creator, index: true, null: false
  end
end
