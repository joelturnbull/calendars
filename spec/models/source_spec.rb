require 'spec_helper'

describe "Source" do
  uri = "http://cincymusic.com/calendar"
  path = "ul.buttons ul:not(.buttons-second-row) li a"
  source = Source.create(uri: uri, path: path)
                      
  it "is a thing" do
    source.should_not be_nil
    source.events.should be_empty
  end

  it "fetches events" do
    source.fetch
    source.events.should_not be_empty
  end

  it "publishes ics" do
    source.fetch
    lambda { RiCal.parse_string(source.publish) }.should_not raise_error
  end
end
