class RemoveOldFields < ActiveRecord::Migration
  def change
    drop_table :conversations_tags

    remove_column :events, :address
    remove_column :events, :neighborhood

    remove_column :places, :address
  end
end
