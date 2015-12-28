class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone_number
      t.string :name
      t.string :email
      t.string :neighborhood
      t.integer :number_of_conversations
      t.binary :needs_response

      t.timestamps null: false
    end
  end
end
