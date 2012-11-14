require 'spec_helper'

describe Location do
  Given(:location) { Location.new(name:'Foo') }
  context "is named" do
    Then { location.name.should == 'Foo' }
  end

  context "events" do
    Given!(:event1) { Event.create(location:location,ics:ics) }
    Given!(:event2) { Event.create(location:location,ics:ics2) }

    context "has many" do
      Then { location.events.should include(event1) }
      Then { location.events.should include(event2) }
    end

    context "dependent destory" do
      When { location.destroy }
      Then { Event.count.should == 0 }
    end

    context "publishes collected events" do
      When(:rical) { RiCal.parse_string(location.publish) }
      Then { rical[0].events.count.should == 2 }
    end

    context "published events across locations" do
      Given(:alt_location) { Location.new(name:'Bar') }
      Given!(:event3) { Event.create(location:alt_location,ics:ics3) }
      When(:rical) { RiCal.parse_string(Location.publish) }
      Then { rical[0].events.count.should == 3 }
    end

    context "publishes an empty caledar" do
      Given { location.events.delete_all }
      When(:rical) { RiCal.parse_string(location.publish) }
      Then { rical[0].events.count.should == 0 }
    end

    context "sets feed on write" do
      Given { flexmock(location).should_receive(:feed=).once }
      When { location.write_file }
      Then { }
    end

    context "creates a master feed and publishes" do
      Given { flexmock(Location).should_receive(:publish).once }
      Given { flexmock(Location).new_instances.should_receive(:save!).and_return("") }
      When { Location.write_file }
      Then { Location.find_by_name(MASTER_FEED_NAME).should_not be_nil }
    end
  end
end

def ics
  "BEGIN:VEVENT\nSEQUENCE:1\nDESCRIPTION:Tweens\nURL;VALUE=URI:http://cincymusic.com/shows/2012/10/tweens2\nSUMMARY:Tweens\nLOCATION:The Comet\\n4579 Hamilton Avenue\\nCincinnati, Cincinnati 45223\nUID:b9d06666d7172070176d8a49e847304e@cincymusic.com\nDTSTART;TZID=US/Eastern:20121030T220000\nDTSTAMP:20121027T143347\nDTEND;TZID=US/Eastern:20121031T010000\nEND:VEVENT\n"
end

def ics2
  "BEGIN:VEVENT\nSEQUENCE:1\nDESCRIPTION:Tweenz\nURL;VALUE=URI:http://cincymusic.com/shows/2012/10/tweens2\nSUMMARY:Tweens\nLOCATION:The Comet\\n4579 Hamilton Avenue\\nCincinnati, Cincinnati 45223\nUID:b9d06666d7172070176d8a49e847304e@cincymusic.com\nDTSTART;TZID=US/Eastern:20121030T220000\nDTSTAMP:20121027T143347\nDTEND;TZID=US/Eastern:20121031T010000\nEND:VEVENT\n"
end

def ics3
  "BEGIN:VEVENT\nSEQUENCE:1\nDESCRIPTION:Tweenx\nURL;VALUE=URI:http://cincymusic.com/shows/2012/10/tweens2\nSUMMARY:Tweens\nLOCATION:The Comet\\n4579 Hamilton Avenue\\nCincinnati, Cincinnati 45223\nUID:b9d06666d7172070176d8a49e847304e@cincymusic.com\nDTSTART;TZID=US/Eastern:20121030T220000\nDTSTAMP:20121027T143347\nDTEND;TZID=US/Eastern:20121031T010000\nEND:VEVENT\n"
end
