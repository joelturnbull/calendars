class LocationsController < ApplicationController

  def index
  end

  private

  def locations
    @feeds ||= Location.order("name")
  end

  def master_feed
    Location
  end

  helper_method :locations,:master_feed
end
