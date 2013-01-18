class SubscriptionStatsDecorator
  def initialize(subscriptions)
    @subscriptions = subscriptions
  end

  def unique
    format_label_value(__method__)
  end
  
  def google
    format_label_value(__method__)
  end

  def webcal
    format_label_value(__method__)
  end

  def ics
    format_label_value(__method__)
  end

  def unknown
    format_label_value(__method__)
  end

  def by_location(location)
    label = location.name
    value = @subscriptions.send __method__, location
    "#{label}: #{value}"
  end

  def format_label_value(sym)
    label = sym.to_s.titleize
    value = @subscriptions.send sym 
    "#{label}: #{value}"
  end

  # Subscription.select("count(*) as sum,location_id,ip,subscription_type").where("created_at > '#{Date.yesterday}'").group([:ip,:location_id,:subscription_type]).order(:ip)
  
end
