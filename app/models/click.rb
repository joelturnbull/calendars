class Subscription < ActiveRecord::Base
  attr_accessible :location, :ip, :subscription_type
  belongs_to :location
end
