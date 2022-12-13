class CreateInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :interests do |t|
      t.string :name

      t.timestamps
    end
    add_reference :interests, :category, foreign_key: true
  end
end
