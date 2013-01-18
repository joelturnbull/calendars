class Subscription < ActiveRecord::Base
  attr_accessible :location, :ip, :subscription_type
  belongs_to :location

  def self.unique
    Subscription.select("count(*)").where("created_at > '#{Date.yesterday}'").group([:ip,:location_id,:subscription_type]).all.count
  end

  def self.type_value(type)
    Subscription.select("count(*)").where("created_at > '#{Date.yesterday}'").where(subscription_type: type).group([:ip,:location_id]).all.count
  end

  def self.google
    type_value(__method__.to_s)
  end
  
  def self.webcal
    type_value(__method__.to_s)
  end

  def self.ics
    type_value(__method__.to_s)
  end

  def self.unknown
    Subscription.select("count(*)").where("created_at > '#{Date.yesterday}'").where("subscription_type is NULL").group([:ip,:location_id]).all.count
  end

  def self.by_location(location)
    Subscription.select("count(*)").where("created_at > '#{Date.yesterday}'").where(location_id:location.id).group([:ip,:subscription_type]).all.count
  end
end
