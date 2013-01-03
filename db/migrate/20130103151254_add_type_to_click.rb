class AddTypeToClick < ActiveRecord::Migration
  def change
    add_column :clicks, :click_type, :string
  end
end
