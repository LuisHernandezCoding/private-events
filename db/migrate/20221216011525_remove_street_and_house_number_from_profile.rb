class RemoveStreetAndHouseNumberFromProfile < ActiveRecord::Migration[7.0]
  def up
    remove_column :profiles, :street
    remove_column :profiles, :house_number
  end
  def down
    add_column :profiles, :street, :string
    add_column :profiles, :house_number, :string
  end
end
