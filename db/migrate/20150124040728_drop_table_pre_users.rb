class DropTablePreUsers < ActiveRecord::Migration
  def change
    drop_table :pre_users
  end
end
