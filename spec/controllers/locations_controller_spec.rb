require 'spec_helper'
describe LocationsController do
  render_views


  describe "GET index" do
    Given { Location.create(name:"Foo") }
    context "returns the index html" do
      When { get :index }
      Then { response.code.should == "200" }
      Then { response.content_type.should == "text/html" }
      Then { response.body.should =~ /Foo/ }
    end
  end

  describe "GET location" do
    use_vcr_cassette
    Given(:location) { Location.create(name:"Foo") }
    Given(:feed) { flexmock("feed").tap { |obj| obj.should_receive(:url).and_return("http://s3.amazonaws.com/music-feeds/location_feeds/All.ics?1353291211") }}
    Given { flexmock(location).tap { |obj| obj.should_receive(:feed).and_return(feed) }}
    Given { flexmock(Location).tap { |obj| obj.should_receive(:find).with(location.id).and_return(location) }}
    context "returns the location ics" do
      When { get :show, :id => location.id }
      Then { response.code.should == "200" }
      Then { response.content_type.should == "text/calendar" }
#      Then { response.headers['Content-Disposition'].should == "attachment" }
      Then { response.body.should =~ /Bar/ }
    end
  end
end
