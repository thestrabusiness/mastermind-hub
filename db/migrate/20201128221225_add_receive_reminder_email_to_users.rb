class AddReceiveReminderEmailToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :receive_reminder_email, :boolean, null: false, index: true, default: true
  end
end