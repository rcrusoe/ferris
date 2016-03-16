class AddFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :approved, :boolean, index: true
  end
end
