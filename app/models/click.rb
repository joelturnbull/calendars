class Click < ActiveRecord::Base
  attr_accessible :location, :ip
  belongs_to :location
end
