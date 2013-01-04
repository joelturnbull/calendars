class RenameClicksToSubscriptions < ActiveRecord::Migration
  def change
    rename_table :clicks, :subscriptions
  end
end
