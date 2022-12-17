class CreateOrganizers < ActiveRecord::Migration[7.0]
  def change
    create_table :organizers do |t|
      t.string :experience
      t.string :team
      t.integer :events_quantity_expectation
      t.integer :events_size_expectation
      t.boolean :is_active, default: true
      t.boolean :is_approved, default: false
      t.boolean :preferences_ticketing, default: false
      t.boolean :preferences_data_collection, default: false
      t.boolean :preferences_publicity, default: false
      t.boolean :preferences_analytics, default: false
      t.boolean :preferences_reputation, default: false
      t.boolean :preferences_marketing, default: false
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
