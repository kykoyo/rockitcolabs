class RemoveUserEventIdFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :user_event_id
  	remove_column :events, :user_event_id
  end
end
