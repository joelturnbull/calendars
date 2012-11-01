class AddFeedToLocations < ActiveRecord::Migration
  def change
    add_attachment :locations, :feed
  end
end
