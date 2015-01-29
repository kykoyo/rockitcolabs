class ChangeFormatInChargeTable < ActiveRecord::Migration
  def change
    rename_column :charges, :charge_type, :day
    change_column :charges, :day, 'integer USING CAST(day AS integer)'
  end
end
