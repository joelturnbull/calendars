class Source < ActiveRecord::Base
  has_many :events
  def fetch
    ics_uris = UriParser.new(tld,path,css_path).parse
    ics_strings = ics_uris.collect { |uri| fetch_ics(uri) }
    events = ics_strings.collect { |string| convert_ics(string) }
    events.each { |event| create_event(event) }
  end

  def publish
    cal = RiCal::Component::Calendar.new
    events.each { |event| cal.events << RiCal.parse_string(event.ics)[0] }
    cal.to_s
  end

  attr_accessible :tld,:path,:css_path
end

private

def fetch_ics(uri)
  Nokogiri::HTML(open(uri)).css("p").children.first.text
end

def convert_ics(string)
  RiCal.parse_string(string)[0].events[0]
end

def create_event(event)
  location_name = event.location.split("\n")[0]
  location = Location.find_or_create_by_name(location_name)
  Event.create( source:self, location:location, ics:event.to_s )  
end
  

