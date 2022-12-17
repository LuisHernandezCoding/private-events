class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.string :date
      t.string :hour
      t.string :country
      t.string :state
      t.string :city
      t.string :is_virtual?

      t.timestamps
    end
  end
end
