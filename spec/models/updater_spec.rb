require 'spec_helper'

describe Updater do
  context "updates" do
    Given(:source) do
      flexmock("source").tap do |obj| 
        obj.should_receive(:fetch).with_no_args.and_return do 
          FactoryGirl.create(:event, location: location )
        end
      end
    end
    Given(:location) { Location.create!(name:"Foo") }
    Given!(:event) { FactoryGirl.create(:event, location: location) }
    Given!(:feed) { location.feed.url }
    When { Updater.update(source); location.reload }

    context "set its url after update" do
      Then { location.feed.url.should_not == feed } 

      context "retains it's url after another update" do
        When { Updater.update(source) }
        Then do 
          feed_uri = URI.parse(location.feed.url)
          new_uri  = URI.parse(location.reload.feed.url) 
          feed_uri.path.should == new_uri.path
        end
      end
    end

    context "replaces events" do
      Then { Event.count.should == 1 }
      Then { Event.first.should_not == event }
    end

    context "preserves locations" do
      Then { Location.count.should == 2 }
    end
    Then { Location.active.count.should == 1 }
  end
end
