module AttachmentSettings

  class << self
    def included(base)
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def has_attachment(name, options = {})

      # Examples: "user_avatars" or "asset_uploads" or "message_previews"
      attachment_owner    = self.table_name.singularize
      attachment_folder   = "#{attachment_owner}_#{name.to_s.pluralize}"
      # we want to create a path for the upload that looks like:
      # message_previews/00/11/22/001122deadbeef/thumbnail.png
      attachment_path     = options.delete(:attachment_path)
      attachment_path     ||= "#{attachment_folder}/:filename"

      if Rails.env.production?
        options[:path]            ||= attachment_path
        options[:storage]         ||= :s3
        options[:s3_credentials] = { access_key_id: ENV['AWS_ACCESS_KEY_ID'] }
        options[:s3_credentials] = { secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] }
        options[:s3_credentials] = { bucket: 'music-feeds' }
        options[:s3_headers] = { 'Content-Type'=> "text/calendar", 'Content-Disposition' => 'attachment' }
      else
        options[:storage] ||= :filesystem
        options[:path]  ||= ":rails_root/public/system/attachments/#{Rails.env}/#{attachment_path}"
        options[:url]   ||= "/system/attachments/#{Rails.env}/#{attachment_path}"
      end

      has_attached_file name, options
    end
  end
end

class Location < ActiveRecord::Base
  include AttachmentSettings
  has_many :events, dependent: :destroy 
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

  def self.feed
    find_by_name(MASTER_FEED_NAME)
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
