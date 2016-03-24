class AddTagsToPlace < ActiveRecord::Migration
  def change
    # drop_table :conversations_tags

    create_join_table :places, :tags do |t|
      t.index [:place_id, :tag_id]
      t.index [:tag_id, :place_id]
    end
  end
end
