class AddTimeToClick < ActiveRecord::Migration
  def change
    add_column(:clicks, :created_at, :datetime)
    add_column(:clicks, :updated_at, :datetime)
  end
end
