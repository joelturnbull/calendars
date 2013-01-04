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

    Given!(:feed) do 
      Location.create!(name:MASTER_FEED_NAME)
      flexmock(Location.master_feed).tap do |obj| 
        obj.should_receive(:url).and_return(feed_url)
      end
    end
    Given do 
      flexmock(Location).tap do |obj| 
        obj.should_receive(:master_feed).and_return(feed)
      end

      flexmock(controller.request).tap do |obj| 
        obj.should_receive(:remote_ip).and_return('123.123.123.123') 
      end
    end

    When { get :index, format: :ics, subscription_type: 'ics'}

    context "returns the master ics" do
      Then { response.code.should == "200" }
      Then { response.content_type.should == "text/calendar" }
      Then { response.body.should =~ /Bar/ }
    end

    context "stores the subscription" do
      Then { Location.subscriptions.count.should == 1 }
      Then { Location.subscriptions.first.ip.should == '123.123.123.123' }
      Then { Location.subscriptions.first.subscription_type.should == 'ics' }
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
      flexmock(controller.request).tap do |obj| 
        obj.should_receive(:remote_ip).and_return('123.123.123.123') 
      end
    end
    
    When { get :show, :id => location.id, format: :ics, subscription_type: 'ics'}

    context "returns the location ics" do
      Then { response.code.should == "200" }
      Then { response.content_type.should == "text/calendar" }
      Then { response.body.should =~ /Bar/ }
    end

    context "stores the subscription" do
      Then { location.subscriptions.count.should == 1 }
      Then { location.subscriptions.first.ip.should == '123.123.123.123' }
      Then { location.subscriptions.first.subscription_type.should == 'ics' }
    end
  end
end
