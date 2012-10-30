class RemoveCssPathFromSource < ActiveRecord::Migration
  def change
    remove_column :sources, :css_path
  end
end
