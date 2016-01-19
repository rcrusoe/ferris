class ChangePhoneNumberFormatInPlaces < ActiveRecord::Migration
  def up
    change_column :places, :phone_number, :string
  end

  def down
    change_column :places, :phone_number, :integer
  end
end
