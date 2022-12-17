class RemoveUserIdAndAddOrganizerToEvents < ActiveRecord::Migration[7.0]
  def up
    remove_reference :events, :user
    add_reference :events, :organizer, null: false, foreign_key: true
  end

  def down
    add_reference :events, :user, null: false, foreign_key: true
    remove_reference :events, :organizer
  end
end
