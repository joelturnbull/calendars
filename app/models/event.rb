class Event < ActiveRecord::Base
  belongs_to :source
  attr_accessible :ics,:source
  validate :ics_is_parsable

  def ics_is_parsable
    begin
      RiCal.parse_string(ics)
    rescue
      errors.add(:ics,"invalid")
    end
  end
end
