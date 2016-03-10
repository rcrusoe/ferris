class CreateOccurrences < ActiveRecord::Migration
  def change
    create_table :occurrences do |t|
      t.references :event, index: true, foreign_key: true
      t.date :date
      t.timestamps null: false
    end
  end
end
