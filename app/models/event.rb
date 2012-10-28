class Event < ActiveRecord::Base
  belongs_to :source
  belongs_to :location
  attr_accessible :ics,:source,:location
  validate :ics_is_parsable

  def ics_is_parsable
    begin
      RiCal.parse_string(ics)
    rescue
      errors.add(:ics,"invalid")
    end
  end
end
