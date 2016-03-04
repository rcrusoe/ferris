class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :messages_count
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
