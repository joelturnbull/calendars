require 'spec_helper'

describe "Source" do
  Given(:tld) { "http://cincymusic.com" }
  Given(:path) { "shows" }
  Given(:source) { Source.create(tld: tld, path: path) }
  Given(:today) { Date.new(2012,10,30) }
  Given  { flexmock(Date).should_receive(:today).and_return(today) }
                      
  context "has events" do
    Then { source.events.should be_empty }
  end

  context "after a fetch" do
    use_vcr_cassette
    When { source.fetch }

    context "has events" do
      Then { source.events.count.should == 189 }
    end

    context "has events for the next 6 months" do
      Then { source.events.order(:datetime_start).first.datetime_start.month.should == Date.today.month }
      Then { source.events.order(:datetime_start).last.datetime_start.month.should == ( Date.today + 6.month ).month }
    end

    context "publishes ics" do
      Then { lambda { RiCal.parse_string(source.publish) }.should_not raise_error }
    end

    context "publishes collected events" do
      Given(:ics) { RiCal.parse_string(source.publish) }
      Then { ics[0].events.count.should == 189 }
    end
  end 
end
