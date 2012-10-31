class LocationsController < ApplicationController

  def index
  end

  private

  def feeds
    @feeds ||= Location.order("name")
  end

  def master_feed
    Location
  end

  helper_method :feeds,:master_feed
end
