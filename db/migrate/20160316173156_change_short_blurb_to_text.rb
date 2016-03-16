class ChangeShortBlurbToText < ActiveRecord::Migration
  def up
    change_column :events, :short_blurb, :text
  end

  def down
    change_column :events, :short_blurb, :string
  end
end
