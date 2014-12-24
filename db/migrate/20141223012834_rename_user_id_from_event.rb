class RenameUserIdFromEvent < ActiveRecord::Migration
  def change
  	rename_column :events, :user_id, :user_event_id
	rename_column :users, :event_id, :user_event_id
  end
end
