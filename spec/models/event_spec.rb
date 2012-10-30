require 'spec_helper'

describe Event do
  Given(:datetime) { DateTime.new(2012,10,31,2) }
  Given(:location) { Location.new(name:'MOTR') }

  context "valid event" do
    Given!(:event) { Event.create!(ics:ics,location: location) }

    context "belongs to a location" do
      Then { event.location.should == location }
    end

    context "has a start_date" do
      Then { event.datetime_start.should == datetime }
    end

    context "rejects duplicates" do
      When { Event.create(ics:ics,location: location) }
      Then { Event.count.should == 1 }
    end
  end

  context "rejects invalid ics" do
    Then { lambda { Event.create!(ics:"bad bad bad") }.should raise_error }
  end
end

def ics
  "BEGIN:VCALENDAR\nVERSION:2.0\nMETHOD:PUBLISH\nX-WR-TIMEZONE:US/Eastern\nPRODID:-//CincyMusic.com//EN\nCALSCALE:GREGORIAN\nX-WR-CALNAME:CincyMusic.com\nBEGIN:VTIMEZONE\nTZID:US/Eastern\nBEGIN:STANDARD\nDTSTART:16011104T020000\nRRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11\nTZOFFSETFROM:-0400\nTZOFFSETTO:-0500\nEND:STANDARD\nBEGIN:DAYLIGHT\nDTSTART:16010311T020000\nRRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3\nTZOFFSETFROM:-0500\nTZOFFSETTO:-0400\nEND:DAYLIGHT\nEND:VTIMEZONE\nBEGIN:VEVENT\nSEQUENCE:1\nDESCRIPTION:Tweens\nURL;VALUE=URI:http://cincymusic.com/shows/2012/10/tweens2\nSUMMARY:Tweens\nLOCATION:The Comet\\n4579 Hamilton Avenue\\nCincinnati, Cincinnati 45223\nUID:b9d06666d7172070176d8a49e847304e@cincymusic.com\nDTSTART;TZID=US/Eastern:20121030T220000\nDTSTAMP:20121027T143347\nDTEND;TZID=US/Eastern:20121031T010000\nEND:VEVENT\nEND:VCALENDAR\n"
end
