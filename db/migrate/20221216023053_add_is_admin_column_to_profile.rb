class AddIsAdminColumnToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :is_admin, :boolean, default: false
  end
end
