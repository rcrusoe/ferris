class AddPlacesToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :place, index: true, foreign_key: true
  end
end
