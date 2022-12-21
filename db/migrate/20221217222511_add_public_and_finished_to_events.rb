class AddPublicAndFinishedToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :public, :boolean, default: false
    add_column :events, :finished, :boolean, default: false
  end
end
