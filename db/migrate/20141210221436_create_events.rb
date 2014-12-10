class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start
      t.datetime :end
      t.integer :organizer_id
      t.integer :participants_id

      t.timestamps
    end
  end
end
