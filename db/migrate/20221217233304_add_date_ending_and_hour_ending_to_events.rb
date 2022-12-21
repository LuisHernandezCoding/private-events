class AddDateEndingAndHourEndingToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :date_ending, :string
    add_column :events, :hour_ending, :string
  end
end
