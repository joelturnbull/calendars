FactoryGirl.define do

  factory :location do
    sequence :name do |n|
      name "Location #{n}"
    end
  end

  factory :subscription do
    location { Location.first || FactoryGirl.create(:location) }
    ip "66.249.75.234"

    factory :google_subscription do
      subscription_type "google"
    end

    factory :webcal_subscription do
      subscription_type "webcal"
    end

    factory :ics_subscription do
      subscription_type "ics"
    end

    factory :unknown_subscription do
      subscription_type nil
    end
  end

end
