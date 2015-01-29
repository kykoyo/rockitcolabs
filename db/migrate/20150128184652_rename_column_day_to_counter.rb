class RenameColumnDayToCounter < ActiveRecord::Migration
  def change
    rename_column :charges, :day, :counter
  end
end
