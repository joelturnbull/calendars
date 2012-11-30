require 'spec_helper'

describe Location do
  Given(:location) { Location.new(name:'Foo') }
  context "is named" do
    Then { location.name.should == 'Foo' }
  end

  context "events" do
    Given!(:event1) { FactoryGirl.create(:event,location:location) }
    Given!(:event2) { FactoryGirl.create(:event,location:location) }

    context "has many" do
      Then { location.events.should include(event1) }
      Then { location.events.should include(event2) }
    end

    context "dependent destroy" do
      When { location.destroy }
      Then { Event.count.should == 0 }
    end

    context "publishes collected events" do
      When(:text) { location.publish }

      context "published calendar has events" do
        When(:rical) { RiCal.parse_string(text) }
        Then { rical[0].events.count.should == 2 }
      end
      
      context "published calendar is named" do
        Then { text.should match "X-WR-CALNAME:Foo" }
        Then { text.should match "X-WR-CALDESC:Foo" }
      end
    end

    context "published events across locations" do
      Given(:alt_location) { Location.new(name:'Bar') }
      Given!(:event3) { FactoryGirl.create(:event,location:alt_location) }
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

    context "published master calendar is named" do
        When(:text) { Location.publish }
        Then { text.should match "X-WR-CALNAME:#{MASTER_FEED_NAME}" }
        Then { text.should match "X-WR-CALDESC:#{MASTER_FEED_NAME}" }
    end
  end
end
