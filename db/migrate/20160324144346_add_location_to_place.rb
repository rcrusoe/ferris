class AddLocationToPlace < ActiveRecord::Migration
  def change
    add_column :places, :lat, :float
    add_column :places, :lng, :float
    add_column :places, :street, :string
    add_column :places, :city, :string
    add_column :places, :state, :string
    add_column :places, :zip, :string
    add_column :places, :country, :string

    # remove_column :events, :address
    # remove_column :events, :neighborhood
  end
end
