class RenameSetTokenColumnToToken < ActiveRecord::Migration
  def change
    rename_column :events, :set_token, :token
  end
end
