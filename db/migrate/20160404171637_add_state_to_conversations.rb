class AddStateToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :pref_begin_time, :date
    add_column :conversations, :pref_end_time, :date
    add_column :conversations, :pref_location, :text
    add_column :conversations, :pref_categories, :text
    add_column :conversations, :needs_human, :boolean, default: false
    add_column :conversations, :state, :integer, default: 0, null: false
    add_column :users, :name, :string, null: true
    add_column :users, :local, :boolean, null: false, default: true
  end
end
