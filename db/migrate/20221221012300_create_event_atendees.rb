class CreateEventAtendees < ActiveRecord::Migration[7.0]
  def change
    create_table :event_atendees do |t|
      t.references :event, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true
      t.boolean :accepted, default: false

      t.timestamps
    end
  end
end
