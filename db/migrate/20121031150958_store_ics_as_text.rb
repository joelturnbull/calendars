class StoreIcsAsText < ActiveRecord::Migration
  def change
    change_column :events, :ics, :text
  end
end
