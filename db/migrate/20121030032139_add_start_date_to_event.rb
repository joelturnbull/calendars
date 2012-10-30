class AddStartDateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :datetime_start, :datetime
  end
end
