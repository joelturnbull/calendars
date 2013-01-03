class Click < ActiveRecord::Base
  attr_accessible :location, :ip, :click_type
  belongs_to :location
end
