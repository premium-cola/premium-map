# encoding: UTF-8
# TODO: Why the fuck do we have to include these manually?
require_relative '../models/product'
require_relative '../models/role'

# TODO: Put into patches
def Array::Lit *a
  a
end

# TODO:  Those as well
class Array
  alias :filter :select
  alias :filter! :select!
end

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
  
  def geojson
    # TODO: We should just return a proper data structure here,
    #       instead of having an extra renderer
    @geopoint = params[:geocode].split(",").map {|c| c.to_f}

    role = Role RoleMap[params[:type].downcase.to_sym]
    product = Product ProductMap[params[:product].downcase.to_sym]
    andv = Array::Lit \
        role.addresses,
        product.addresses
    @addresses = andv
        .reject(&:empty?)
        .reduce {|a,b| a & b }
        .sort_by {|a| a.distance @geopoint }
  end

end
