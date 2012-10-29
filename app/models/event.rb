class Event < ActiveRecord::Base
  belongs_to :source
  belongs_to :location
  attr_accessible :ics,:source,:location
  validate :ics_is_parsable, :ics_is_unique

  def ics_is_parsable
    begin
      RiCal.parse_string(ics)
    rescue
      errors.add(:ics,"invalid")
    end
  end

  def ics_is_unique
    if Event.find_by_ics(ics)
      errors.add(:ics,"not unique")
    end
  end
end
