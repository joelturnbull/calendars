class LocationsController < ApplicationController

  def index
  end

  private

  def locations
    @feeds ||= Location.order("name")
  end

  def master_location
    @master_location ||= Location.find_by_name("ALL")
  end

  helper_method :locations,:master_location
end
