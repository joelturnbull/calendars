namespace :fetch do 
  task :cm => :environment do
    tld = "http://cincymusic.com"
    path = "calendar"
    css_path = "ul.buttons ul:not(.buttons-second-row) li a"
    source = Source.new( tld: tld, path: path, css_path: css_path ) 
    source.fetch
    Location.all.each do |location|
      File.open("public/#{location.name}.ics","w") do |f| 
        f.write(location.publish)
      end
    end
  end
end
