class AddPublicProfileToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :public_profile, :boolean, default: false
  end
end
