class LocationsController < ApplicationController

  def index
  end

  def show
    headers['Content-Type'] = "text/calendar"
    location = Location.find(params[:id].to_i)
    render :text => Net::HTTP.get(URI(location.feed.url)), :content_type => 'text/calendar'

  end

  private

  def locations
    @feeds ||= Location.order("name")
  end

  def master_location
    @master_location ||= Location.master_feed
  end

  helper_method :locations,:master_location
end
