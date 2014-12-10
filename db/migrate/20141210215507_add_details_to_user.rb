class AddDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone, :integer
    add_column :users, :add_start, :datetime
    add_column :users, :add_end, :datetime
    add_column :users, :ent_start, :datetime
    add_column :users, :ent_end, :datetime
    add_column :users, :event_id, :integer
    add_column :users, :creator_id, :integer
  end
end
