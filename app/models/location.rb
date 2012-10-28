class Location < ActiveRecord::Base
  has_many :events
  attr_accessible :name
  
  def publish
    cal = RiCal::Component::Calendar.new
    events.each { |event| cal.events << RiCal.parse_string(event.ics)[0] }
    cal.to_s
  end
end
