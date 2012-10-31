class LocationsController < ApplicationController

  def index
  end

  private

  def feeds
    @feeds ||= Location.order("name")
    @feeds.unshift Location
  end
  helper_method :feeds
end
