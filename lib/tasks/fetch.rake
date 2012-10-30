namespace :fetch do 
  task :cm => :environment do
    tld = "http://cincymusic.com"
    path = "calendar"
    css_path = "ul.buttons ul:not(.buttons-second-row) li a"
    source = Source.new( tld: tld, path: path, css_path: css_path ) 

    Location.delete_all
    source.fetch
    Location.write_files
    Source.write_file
  end
end
