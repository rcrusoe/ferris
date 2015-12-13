class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.date :date
      t.time :start_time
      t.time :end_time
      t.string :address
      t.string :website
      t.integer :price
      t.string :purchase_url

      t.timestamps null: false
    end
    add_attachment :events, :image
  end
end
