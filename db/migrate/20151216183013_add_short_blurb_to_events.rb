class AddShortBlurbToEvents < ActiveRecord::Migration
  def change
    add_column :events, :short_blurb, :string
  end
end
