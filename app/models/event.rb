class Event < ActiveRecord::Base
  belongs_to :source
  belongs_to :location
  attr_accessible :ics,:source,:location, :datetime_start
  validate :ics_is_parsable, :ics_is_unique

  before_save :set_datetime_start

  def ics_is_parsable
    begin
      parse_cal
    rescue
      errors.add(:ics,"invalid")
    end
  end

  def ics_is_unique
    if Event.find_by_ics(ics)
      errors.add(:ics,"not unique")
    end
  end

  def cal
    @cal ||= adjusted_cal
  end

  def adjusted_cal
    rical = parse_cal
    rical.tap{ |cal| cal.description = "#{cal.description}\n#{cal.url}" }
  end

  def parse_cal
    RiCal.parse_string(ics).first
  end

  def set_datetime_start
    self.datetime_start = cal.dtstart
  end

  def publish
    cal.to_s
  end
end
