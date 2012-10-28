class CreateEvent < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :source_id
      t.string :ics
      t.timestamps
    end
  end
end
