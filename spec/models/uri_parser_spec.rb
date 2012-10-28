require 'spec_helper'

describe UriParser do
  use_vcr_cassette
  Given(:tld) { "http://cincymusic.com" }
  Given(:path) { "calendar" }
  Given(:css_path) { "ul.buttons ul:not(.buttons-second-row) li a" }
  Given(:parser) { UriParser.new(tld,path,css_path) }
  When(:uris) { parser.parse }
  Then { uris.count.should == 25 }
  Then { uris.each { |uri| uri.should =~ /^http.*ics$/ }}
end
