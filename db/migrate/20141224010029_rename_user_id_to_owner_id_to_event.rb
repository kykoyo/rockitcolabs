class RenameUserIdToOwnerIdToEvent < ActiveRecord::Migration
  def change
    rename_column :events, :user_id, :owner_id
  end
end
