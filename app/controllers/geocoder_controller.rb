# encoding: UTF-8

class GeocoderController < ApplicationController
  caches_action :geocode, :expires_in => 300.seconds

  def geocoder
    p = Geocoder.search(params["q"].to_s).first
    # TODO: Result should be indicated by HTTP code

    return render_json result: 'error' unless p
    return render_json \
      result: 'ok',
      coord: {
        lat: p.latitude,
        lng: p.longtitude
      }
  end
end
