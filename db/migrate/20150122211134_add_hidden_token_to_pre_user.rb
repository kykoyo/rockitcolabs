class AddHiddenTokenToPreUser < ActiveRecord::Migration
  def change
    add_column :pre_users, :hidden_token, :string
  end
end
