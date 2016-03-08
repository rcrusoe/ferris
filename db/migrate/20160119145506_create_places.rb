class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :neighborhood
      t.string :website
      t.string :phone_number




      t.boolean :monday_open
      t.time :monday_open_time
      t.time :monday_close_time
      t.boolean :tuesday_open
      t.time :tuesday_open_time
      t.time :tuesday_close_time
      t.boolean :wednesday_open
      t.time :wednesday_open_time
      t.time :wednesday_close_time
      t.boolean :thursday_open
      t.time :thursday_open_time
      t.time :thursday_close_time
      t.boolean :friday_open
      t.time :friday_open_time
      t.time :friday_close_time
      t.boolean :saturday_open
      t.time :saturday_open_time
      t.time :saturday_close_time
      t.boolean :sunday_open
      t.time :sunday_open_time
      t.time :sunday_close_time

      t.timestamps null: false
    end
  end
end
