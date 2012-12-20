class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.integer :location_id
      t.string  :ip
    end
  end
end
