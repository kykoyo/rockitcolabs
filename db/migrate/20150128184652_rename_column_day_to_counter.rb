class RenameColumnDayToCounter < ActiveRecord::Migration
  def change
    rename_column :charges, :count, :counter
  end
end
