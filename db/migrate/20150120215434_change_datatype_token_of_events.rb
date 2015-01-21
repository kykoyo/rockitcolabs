class ChangeDatatypeTokenOfEvents < ActiveRecord::Migration
  def change
    change_column :events, :token, :string
  end
end
