class RenameUritld < ActiveRecord::Migration
  def change
    rename_column :sources, :uri, :tld
  end
end
