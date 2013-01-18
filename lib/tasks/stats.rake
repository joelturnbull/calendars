namespace :stats do
  task :print => :environment do
    subscriptions = SubscriptionStatsDecorator.new(Subscription)
    puts "#{subscriptions.unique}"
    puts "#{subscriptions.google}"
    puts "#{subscriptions.webcal}"
    puts "#{subscriptions.ics}"
    puts "#{subscriptions.unknown}"
    puts ""
    Location.all.each do |l|
      puts "#{subscriptions.by_location(l)}"
    end
  end
end
