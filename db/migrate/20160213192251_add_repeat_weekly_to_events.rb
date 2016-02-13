class AddRepeatWeeklyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :repeat_weekly, :boolean
  end
end
