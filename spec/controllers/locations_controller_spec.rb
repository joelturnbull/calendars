require 'spec_helper'
describe LocationsController do
  render_views

  Given(:feed_url) { "http://s3.amazonaws.com/music-feeds/location_feeds/All.ics?1353291211" }

  describe "GET index" do
    Given { Location.create(name:"Foo") }
    context "returns the index html" do
      When { get :index }
      Then { response.code.should == "200" }
      Then { response.content_type.should == "text/html" }
      Then { response.body.should =~ /Foo/ }
    end
  end

  describe "GET index ics" do
    use_vcr_cassette

    Given(:feed) do 
      flexmock("feed").tap do |obj| 
        obj.should_receive(:url).and_return(feed_url)
      end
    end
    Given do 
      flexmock(Location).tap do |obj| 
        obj.should_receive(:feed).and_return(feed)
      end
    end

    context "returns the master ics" do
      When { get :index, format: :ics}
      Then { response.code.should == "200" }
      Then { response.content_type.should == "text/calendar" }
      Then { response.body.should =~ /Bar/ }
    end
  end

  describe "GET location" do
    use_vcr_cassette

    Given(:location) { Location.create(name:"Foo") }
    Given(:feed) do
      flexmock("feed").tap do |obj| 
        obj.should_receive(:url).and_return(feed_url)
      end
    end
    Given do
      flexmock(location).tap do |obj| 
        obj.should_receive(:feed).and_return(feed)
      end
      flexmock(Location).tap do |obj| 
        obj.should_receive(:find).with(location.id).and_return(location) 
      end
    end
    
    context "returns the location ics" do
      When { get :show, :id => location.id, format: :ics }
      Then { response.code.should == "200" }
      Then { response.content_type.should == "text/calendar" }
      Then { response.body.should =~ /Bar/ }
    end
  end
end
