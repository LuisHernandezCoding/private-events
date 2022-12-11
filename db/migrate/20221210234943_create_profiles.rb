class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :title
      t.string :birthday
      t.string :country
      t.string :street
      t.string :house_number
      t.string :city
      t.string :state
      t.string :phone
      t.boolean :terms
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
