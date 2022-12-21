class AddEditingToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :editing, :boolean, default: false
  end
end
