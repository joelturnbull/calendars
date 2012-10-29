require 'spec_helper'

describe Location do
  Given(:location) { Location.new(name:'The Comet') }

  context "is named" do
    Then { location.name.should == 'The Comet' }
  end

  context "events" do
    Given!(:event1) { Event.create(location:location,ics:ics) }
    Given!(:event2) { Event.create(location:location,ics:ics) }

    context "has many" do
      Then { location.events.should include(event1) }
      Then { location.events.should include(event2) }
    end

    context "publishes collected events" do
      When(:rical) { RiCal.parse_string(location.publish) }
      Then { rical[0].events.count.should == 2 }
    end


  end
end

def ics
  "BEGIN:VEVENT\nSEQUENCE:1\nDESCRIPTION:Tweens\nURL;VALUE=URI:http://cincymusic.com/shows/2012/10/tweens2\nSUMMARY:Tweens\nLOCATION:The Comet\\n4579 Hamilton Avenue\\nCincinnati, Cincinnati 45223\nUID:b9d06666d7172070176d8a49e847304e@cincymusic.com\nDTSTART;TZID=US/Eastern:20121030T220000\nDTSTAMP:20121027T143347\nDTEND;TZID=US/Eastern:20121031T010000\nEND:VEVENT\n"
end
