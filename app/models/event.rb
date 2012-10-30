class Event < ActiveRecord::Base
  belongs_to :source
  belongs_to :location
  attr_accessible :ics,:source,:location, :datetime_start
  validate :ics_is_parsable, :ics_is_unique

  before_save :set_datetime_start

  def ics_is_parsable
    begin
      @cal = RiCal.parse_string(ics)
    rescue
      errors.add(:ics,"invalid")
    end
  end

  def ics_is_unique
    if Event.find_by_ics(ics)
      errors.add(:ics,"not unique")
    end
  end

  def set_datetime_start
    @cal ||= generate_cal 
    self.datetime_start = @cal[0].dtstart
  end
end
