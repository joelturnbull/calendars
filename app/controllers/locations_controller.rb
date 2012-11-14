class LocationsController < ApplicationController

  def index
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
