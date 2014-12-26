# encoding: UTF-8
# TODO: Why the fuck do we have to include these manually?
require_relative '../models/product'
require_relative '../models/role'

class GeojsonController < ApplicationController
  caches_action :geojson, :expires_in => 300.seconds

  # TODO: Those maps are fucked up, just use decent, full
  # names
  RoleMap = Hash \
    s: :speaker,
    d: :merchant,
    l: :store

  ProductMap = Hash \
    c: :cola,
    b: :beer

  # TODO: This should be resourceful inside addresses
  def geojson
    # TODO: We should just return a proper data structure here,
    #       instead of having an extra renderer
    # TODO: Pass the point as data
    geopoint = params[:geocode].split(",").map {|c| c.to_f}

    role = Role RoleMap[params[:type].downcase.to_sym]
    product = Product ProductMap[params[:product].downcase.to_sym]
    andv = Array.Lit \
        role.addresses,
        product.addresses
    addrs = andv
        .reject(&:empty?)
        .reduce {|a,b| a & b }
        #.sort_by {|a| a.distance @geopoint }

    # TODO: The type property is redundant
    # TODO: We should just dump the model
    fmt_adr = addrs.map do |a|
      biz_name = a.business_name
      xtrac = Array.Lit :street, :city, :zipcode, :country,
        :web, :email, :telehone
      geo = Hash \
        type: :Point,
        coordinates: [a.longitude, a.latitude]
      props = a.attrs.extract!(*xtrac)
        .merge \
          company: biz_name.empty? ? " - " : biz_name,
          products: a.products.map(&:name).join(", "), # TODO: Wtf, return a fucking array!
          distance: a.distance(geopoint)
      Hash \
        properties: props,
        geometry: geo,
        type: "Feature" # TODO: Formatting for leaflet should be done by JS
    end
    render_json type: :FeatureCollection, features: fmt_adr
  end
end
