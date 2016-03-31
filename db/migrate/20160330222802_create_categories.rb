class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :keywords
      t.string :icon, null: true
      t.timestamps null: false
    end

    add_reference :events, :category, index: true, foreign_key: true, null: true
  end
end
