class RenameClickTypeToSubscriptionType < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :click_type, :subscription_type
  end
end
