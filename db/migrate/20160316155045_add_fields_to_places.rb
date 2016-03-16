class AddFieldsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :fb_id, :string
    add_column :places, :fb_likes, :integer, index: true
    add_column :places, :fb_checkins, :integer, index: true
    add_column :places, :approved, :boolean, index: true, default: true
    add_column :places, :email, :string
    add_column :places, :fb_link, :text
    add_column :places, :price_range, :string
    add_column :places, :about, :text
  end
end
