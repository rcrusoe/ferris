class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float :lat
      t.float :lng

      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.string :neighborhood

      t.belongs_to :place, index: true
      t.timestamps null: false
    end
  end
end