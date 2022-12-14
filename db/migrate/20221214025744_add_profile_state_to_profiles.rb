class AddProfileStateToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :profile_state, :string, default: 'none'
  end
end
