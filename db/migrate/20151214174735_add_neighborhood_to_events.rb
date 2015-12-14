class AddNeighborhoodToEvents < ActiveRecord::Migration
  def change
    add_column :events, :neighborhood, :string
  end
end
