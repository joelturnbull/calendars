class Location < ActiveRecord::Base
  has_many :events, dependent: :destroy 
  attr_accessible :name

  def self.write_files
    all.each do |location|
      write_file(location)
    end
  end

  def self.write_file(location)
    File.open("public/#{location.feed_name}.ics","w") do |f| 
      f.write(location.publish)
    end
  end

  def publish
    cal = RiCal::Component::Calendar.new
    events.each { |event| cal.events << RiCal.parse_string(event.ics)[0] }
    cal.to_s
  end

  def self.publish
    cal = RiCal::Component::Calendar.new
    Location.all.each do |location|
      location.add_events(cal) 
    end
    cal.to_s
  end

  def add_events(cal)
    events.each { |event| cal.events << RiCal.parse_string(event.ics)[0] }
  end

  def feed_name
    name
  end

  def self.feed_name
    "ALL Feeds"
  end

  def url
    "#{name}.ics"
  end

  def self.url
    "#{feed_name}.ics"
  end

  def last_update
    events.first.created_at.strftime('%Y/%m/%d')
  end

  def self.last_update
    Location.first.events.first.created_at.strftime('%Y/%m/%d')
  end
end
