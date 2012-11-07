class Location < ActiveRecord::Base
  has_many :events, dependent: :destroy 
  has_attached_file :feed, s3_credentials: { access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], bucket: 'music-feeds' }, storage: :s3, s3_headers: { 'Content-Type'=> "text/calendar", 'Content-Disposition' => 'attachment' }
  attr_accessible :name, :feed

  def self.write_files
    all.each do |location|
      location.write_file
    end
    Location.write_file
  end

  def self.write_file
    master_location = Location.find_or_create_by_name("ALL")
    master_location.write_file(Location)
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
    add_events(cal)
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
    events.each { |event| cal.events << event.cal }
  end

  def feed_name
    name
  end

  def self.feed_name
    "ALL"
  end

  def ical_url
    "webcal://#{CGI.escape(feed.url.gsub("http://",""))}"
  end

  def google_url
    "http://www.google.com/calendar/render?cid=#{CGI.escape(feed.url)}"
  end

  def last_update
    Location.first.events.first.created_at.strftime('%Y/%m/%d')
  end
end
