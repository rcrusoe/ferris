class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklist do |t|
      t.string :fb_id
      t.string :name

      t.timestamps null: false
    end
  end
end
