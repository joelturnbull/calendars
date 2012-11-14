class UriParser
  require 'open-uri'

  def initialize(tld,path)
    @tld = tld
    @path = path
  end

  def parse
    ics_uris = Set.new
    uris.each do |uri|
      page = JSON.parse(open(uri).read)
      page["data"]["events"].inject(ics_uris) do |ics_uris,event| 
        ics_uris << "#{@tld}/#{@path}/#{event['slug']}.ics"
      end
    end
    ics_uris
  end
    
  private 

  def uris
    page_param = ""
    page = JSON.parse(open(uri("")).read)
    num_pages = page["data"]["total_pages"]

    (1..num_pages).inject(Array.new) do |uris,page| 
      page_param = "page=#{page}&"
      uris << uri(page_param)
    end
  end

  def uri(page_param)
    uri = "http://cincymusic.com/calendar/events.ajax?#{page_param}date_start=#{Date.today}&date_end=#{Date.today + MONTHS_OF_DATA.months }"
  end

end
