namespace :fetch do 
  task :cm => :environment do
    tld = "http://cincymusic.com"
    path = "shows"
    Updater.update(Source.new( tld: tld, path: path ))

    Event.delete_all
    source.fetch
    Location.write_files
  end
end
