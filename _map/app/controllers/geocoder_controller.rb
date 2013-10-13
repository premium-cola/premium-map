# encoding: UTF-8

class GeocoderController < ApplicationController
  caches_action :geocode, :expires_in => 300.seconds

  def geocoder
    @geocoded = Geocoder.search(params["q"].to_s).first
  end

end
