class RemoveBusinessHoursFromPlaces < ActiveRecord::Migration
  def up
    remove_column :places, :monday_open
    remove_column :places, :monday_open_time
    remove_column :places, :monday_close_time

    remove_column :places, :tuesday_open
    remove_column :places, :tuesday_open_time
    remove_column :places, :tuesday_close_time

    remove_column :places, :wednesday_open
    remove_column :places, :wednesday_open_time
    remove_column :places, :wednesday_close_time

    remove_column :places, :thursday_open
    remove_column :places, :thursday_open_time
    remove_column :places, :thursday_close_time

    remove_column :places, :friday_open
    remove_column :places, :friday_open_time
    remove_column :places, :friday_close_time

    remove_column :places, :saturday_open
    remove_column :places, :saturday_open_time
    remove_column :places, :saturday_close_time

    remove_column :places, :sunday_open
    remove_column :places, :sunday_open_time
    remove_column :places, :sunday_close_time
  end

  def down
    add_column :places, :monday_open, :boolean
    add_column :places, :monday_open_time, :time
    add_column :places, :monday_close_time, :time

    add_column :places, :tuesday_open, :boolean
    add_column :places, :tuesday_open_time, :time
    add_column :places, :tuesday_close_time, :time

    add_column :places, :wednesday_open, :boolean
    add_column :places, :wednesday_open_time, :time
    add_column :places, :wednesday_close_time, :time

    add_column :places, :thursday_open, :boolean
    add_column :places, :thursday_open_time, :time
    add_column :places, :thursday_close_time, :time

    add_column :places, :friday_open, :boolean
    add_column :places, :friday_open_time, :time
    add_column :places, :friday_close_time, :time

    add_column :places, :saturday_open, :boolean
    add_column :places, :saturday_open_time, :time
    add_column :places, :saturday_close_time, :time

    add_column :places, :sunday_open, :boolean
    add_column :places, :sunday_open_time, :time
    add_column :places, :sunday_close_time, :time
  end
end
