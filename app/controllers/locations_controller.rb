class LocationsController < ApplicationController

  def index
    respond_to do |format| 
      format.html
      format.ics do
        render :text => Net::HTTP.get(URI(Location.feed.url)), :content_type => 'text/calendar'
      end
    end
  end

  def show
    respond_to do |format| 
      format.ics do
        headers['Content-Type'] = "text/calendar"
        location = Location.find(params[:id].to_i)
        render :text => Net::HTTP.get(URI(location.feed.url)), :content_type => 'text/calendar'
      end
    end
  end

  private

  def locations
    @feeds ||= Location.order("name").where("name != '#{MASTER_FEED_NAME}'")
  end

  helper_method :locations
end
