class CreateProfileInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :profile_interests do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :interest, null: false, foreign_key: true

      t.timestamps
    end
  end
end
