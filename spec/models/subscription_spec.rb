require 'spec_helper'

describe Subscription do

  context 'returns a unique subscription per ip / subscription type / location' do
    Given do 
      FactoryGirl.create(:google_subscription, ip: "1.1.1.1")
      FactoryGirl.create(:google_subscription, ip: "1.1.1.1")
      FactoryGirl.create(:google_subscription, ip: "2.2.2.2")
      FactoryGirl.create(:webcal_subscription, ip: "1.1.1.1")
      FactoryGirl.create(:webcal_subscription, ip: "1.1.1.1", location_id: 999)
    end
    Then { Subscription.unique.should == 4 }
  end
  
  ["google","webcal","ics","unknown"].each do |type|
    context 'returns unique #{type} subscriptions per location / ip' do
      Given do
        type_factory = "#{type}_subscription".to_sym
        FactoryGirl.create(type_factory, ip: "1.1.1.1")
        FactoryGirl.create(type_factory, ip: "1.1.1.1")
        FactoryGirl.create(type_factory, ip: "2.2.2.2")
        FactoryGirl.create(type_factory, ip: "2.2.2.2", location_id: 999)
      end
      Then do
        value = Subscription.send type.to_sym 
        value.should == 3
      end
    end
  end

  context 'returns a unique subscription per location / type' do
    Given (:location_a) { FactoryGirl.build(:location) }
    Given (:location_b) { FactoryGirl.build(:location) }
    Given (:location_c) { FactoryGirl.build(:location) }
    Given do 
      FactoryGirl.create(:google_subscription, ip: "1.1.1.1", location: location_a)
      FactoryGirl.create(:google_subscription, ip: "1.1.1.1", location: location_a)
      FactoryGirl.create(:google_subscription, ip: "2.2.2.2", location: location_a)
      FactoryGirl.create(:webcal_subscription, ip: "1.1.1.1", location: location_a)
      FactoryGirl.create(:webcal_subscription, ip: "1.1.1.1", location: location_b)
    end
    Then do
      Subscription.by_location(location_a).should == 3
      Subscription.by_location(location_b).should == 1
    end
  end
end

