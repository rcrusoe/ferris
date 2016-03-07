class AddPlacesToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :place, index: true, foreign_key: true, null: true
  end
end
