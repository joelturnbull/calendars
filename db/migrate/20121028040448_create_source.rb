class CreateSource < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :uri
      t.string :path
      t.timestamps
    end
  end
end
