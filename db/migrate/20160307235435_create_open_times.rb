class CreateOpenTimes < ActiveRecord::Migration
  def change
    create_table :open_times do |t|
      t.references :place, index: true, foreign_key: true
      t.integer :day
      t.time :open_time
      t.time :close_time
      t.timestamps null: false
    end
  end
end
