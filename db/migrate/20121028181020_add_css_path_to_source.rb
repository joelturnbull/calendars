class AddCssPathToSource < ActiveRecord::Migration
  def change
    add_column :sources, :css_path, :string
  end
end
