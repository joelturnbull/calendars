class Location < ActiveRecord::Base
  include AttachmentSettings
  has_many :events, dependent: :destroy 
  has_many :subscriptions, dependent: :destroy
  has_attachment :feed
  attr_accessible :name, :feed

  def self.active
    joins(:events)
  end

  def self.last_update
    if location = order("created_at DESC").detect { |location| !location.events.empty? }
      location.events.first.created_at
    end
  end

  def self.master_feed
    self.find_by_name(MASTER_FEED_NAME)
  end

  def self.write_files
    all.each do |location|
      location.write_file
    end
    Location.write_file
  end

  def self.write_file
    master_location = Location.find_or_create_by_name(MASTER_FEED_NAME)
    master_location.write_file(Location)
  end

  def self.subscriptions
    master_feed.subscriptions
  end

  def record_subscription_from_ip(ip,type)
    Subscription.create!(location: self, ip: ip, subscription_type: type )
  end

  def write_file(publisher = self)
    filepath = "./tmp/#{publisher.feed_name}.ics"
    File.open(filepath,"w") do |f| 
      f.write(publisher.publish)
    end
    self.feed = File.open(filepath)
    self.save!
    File.unlink
  end

  def publish
    cal = RiCal::Component::Calendar.new
    cal.add_x_property('X-WR-CALNAME',name)
    cal.add_x_property('X-WR-CALDESC',name)
    add_events(cal)
    cal.to_s.gsub("::",":")
  end

  def self.publish
    cal = RiCal::Component::Calendar.new
    cal.add_x_property('X-WR-CALNAME',MASTER_FEED_NAME)
    cal.add_x_property('X-WR-CALDESC',MASTER_FEED_NAME)
    Location.all.each do |location|
      location.add_events(cal) 
    end
    cal.to_s.gsub("::",":")
  end

  def add_events(cal)
    events.each { |event| cal.events << event.cal }
  end

  def feed_name
    name
  end

  def self.feed_name
    MASTER_FEED_NAME
  end

  def ical_url
    "webcal://#{CGI.escape(feed.url.gsub("http://",""))}"
  end

  def google_url
    "http://www.google.com/calendar/render?cid=#{CGI.escape(feed.url)}"
  end
end
