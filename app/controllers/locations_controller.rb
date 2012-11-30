class LocationsController < ApplicationController

  def index
    respond_to do |format| 
      format.html
      format.ics do
        headers['Content-Disposition'] = "attachment"
        render :text => Net::HTTP.get(URI(Location.feed.url)), :content_type => 'text/calendar'
      end
    end
  end

  def show
    headers['Content-Disposition'] = "attachment"
    location = Location.find(params[:id].to_i)
    render :text => Net::HTTP.get(URI(location.feed.url)), :content_type => 'text/calendar'
  end

  private

  def locations
    @feeds ||= Location.order("name").where("name != '#{MASTER_FEED_NAME}'")
  end

  def google_subscribe_link(location)
    "http://www.google.com/calendar/render?cid=#{CGI.escape(location_url(location))}"
  end

  def ical_subscribe_link(location)
   "webcal://#{CGI.escape(location_url(location).gsub("http://",""))}"
  end

  def ics_link(location)
    location_url(location)
  end
  helper_method :locations, :google_subscribe_link, :ical_subscribe_link, :ics_link
end
