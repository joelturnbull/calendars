MASTER_FEED_NAME = "Cincinnati Live Music Calendar"

case Rails.env
  when "test"
    MONTHS_OF_DATA = 6
  when "development"
    MONTHS_OF_DATA = 1
  when "staging"
    MONTHS_OF_DATA = 6
  when "production"  
    MONTHS_OF_DATA = 6
end
