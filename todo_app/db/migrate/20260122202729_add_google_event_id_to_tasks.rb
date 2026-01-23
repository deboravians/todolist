class AddGoogleEventIdToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :google_event_id, :string
  end
end
