class Location < ActiveRecord::Base
  has_many :events, dependent: :destroy 
  attr_accessible :name

  def self.write_files
    all.each do |location|
      File.open("public/#{location.name}.ics","w") do |f| 
        f.write(location.publish)
      end
    end
  end

  def publish
    cal = RiCal::Component::Calendar.new
    events.each { |event| cal.events << RiCal.parse_string(event.ics)[0] }
    cal.to_s
  end

  def url
    "#{name}.ics"
  end
end
