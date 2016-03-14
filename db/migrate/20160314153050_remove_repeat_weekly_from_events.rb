class RemoveRepeatWeeklyFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :repeat_weekly
  end
end
