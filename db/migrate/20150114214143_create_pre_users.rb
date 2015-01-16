class CreatePreUsers < ActiveRecord::Migration
  def change
    create_table :pre_users do |t|
      t.string :name
      t.string :email
      t.string :user_type
      t.datetime :expired_time

      t.timestamps
    end
  end
end
