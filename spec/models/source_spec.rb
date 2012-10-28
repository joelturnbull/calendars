require 'spec_helper'

describe "Source" do
  Given(:tld) { "http://cincymusic.com" }
  Given(:path) { "calendar" }
  Given(:css_path) { "ul.buttons ul:not(.buttons-second-row) li a" }
  Given(:source) { Source.create(tld: tld, path: path, css_path: css_path) }
                      
  context "has events" do
    Then { source.events.should be_empty }
  end

  context "after a fetch" do
    use_vcr_cassette
    When { source.fetch }

    context "has events" do
      Then { source.events.count.should == 25 }
    end

    it "publishes ics" do
      lambda { RiCal.parse_string(source.publish) }.should_not raise_error
    end

    it "publishes collected events" do
      ics = RiCal.parse_string(source.publsh)
      
    end
    
  end
end
