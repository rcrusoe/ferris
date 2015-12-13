class AddPurchaseToEvent < ActiveRecord::Migration
  def change
    add_column :events, :purchase_url, :string
  end
end
