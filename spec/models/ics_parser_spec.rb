require 'spec_helper'

describe IcsUriParser do
  Given(:uri) { "http://cincymusic.com/calendar" }
  Given(:path) { "ul.buttons ul:not(.buttons-second-row) li a" }
  Given(:parser) { ICSParser.new(uri,path) }
  When(:uris) { parser.parse }
  
