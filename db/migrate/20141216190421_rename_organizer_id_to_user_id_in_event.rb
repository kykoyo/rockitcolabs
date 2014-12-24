class RenameOrganizerIdToUserIdInEvent < ActiveRecord::Migration
  def change
  	rename_column :events, :organizer_id, :user_id
  end
end
