require 'spec_helper'

describe UriParser do
  use_vcr_cassette
  Given(:today) { Date.new(2012,10,30) }
  Given  { flexmock(Date).should_receive(:today).and_return(today) }
  Given(:tld) { "http://cincymusic.com" }
  Given(:path) { "shows" }
  Given(:parser) { UriParser.new(tld,path) }
  When(:uris) { parser.parse }
  Then { uris.count.should == 189 }
  Then { uris.each { |uri| uri.should =~ /^http.*ics$/ }}
end
