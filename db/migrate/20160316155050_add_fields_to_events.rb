class AddFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :fb_id, :string
    add_column :events, :approved, :boolean, index: true, default: true
    add_column :events, :attending_count, :integer
    add_column :events, :maybe_count, :integer
    add_column :events, :interested_count, :integer
  end
end
