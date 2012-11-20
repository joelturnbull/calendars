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
    respond_to do |format| 
        headers['Content-Disposition'] = "attachment"
        location = Location.find(params[:id].to_i)
        render :text => Net::HTTP.get(URI(location.feed.url)), :content_type => 'text/calendar'
    end
  end

  private

  def locations
    @feeds ||= Location.order("name").where("name != '#{MASTER_FEED_NAME}'")
  end

  def google_subscribe_link(location)
    "http://www.google.com/calendar/render?cid=#{CGI.escape(locations_url(location))}"
  end

  def ical_subscribe_link(location)
   "webcal://#{CGI.escape(locations_url(location).gsub("http://",""))}"
  end

  helper_method :locations, :google_subscribe_link, :ical_subscribe_link
end
