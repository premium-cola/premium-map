# encoding: UTF-8

class GeocoderController < ApplicationController

  def geocoder
    p = Geocoder.search(params["q"].to_s).first
    # TODO: Result should be indicated by HTTP code

    return render_json result: 'error' unless p
    return render_json \
      result: 'ok',
      coord: {
        lat: p.latitude,
        lng: p.longitude
      }
  end
end
