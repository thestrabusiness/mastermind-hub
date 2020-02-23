class AddDurationToTimers < ActiveRecord::Migration[6.0]
  def change
    add_column :timers,
               :duration,
               :bigint,
               null: false,
               default: fifteen_minutes
  end

  def fifteen_minutes
    15 * 60
  end
end
