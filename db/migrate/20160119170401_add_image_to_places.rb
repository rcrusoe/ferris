class AddImageToPlaces < ActiveRecord::Migration
  def change
  end
  add_attachment :places, :image
end
