class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.timestamps null: false
    end

    # join table, one tag has many conversations, one conversation has many tags
    create_table :conversations_tags, id: false do |t|
      t.belongs_to :conversation, index: true
      t.belongs_to :tag, index: true
    end
  end
end
