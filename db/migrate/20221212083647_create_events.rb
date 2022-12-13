class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.belongs_to :user
      t.string :name
      t.string :date
      t.string :location
      t.string :description
      t.string :category
      t.string :ticketing
      t.string :age_restriction

      t.timestamps
    end
  end
end
