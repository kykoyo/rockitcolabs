class CreateEnterLogs < ActiveRecord::Migration
  def change
    create_table :enter_logs do |t|
      t.string :email
      t.boolean :enter

      t.timestamps
    end
  end
end
