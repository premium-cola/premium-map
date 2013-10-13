# encoding: UTF-8

class MapsController < ApplicationController
  before_filter :authenticate_user!, :except => [:kml, :embed]

  def embed
    render layout: nil
  end

  def kml
    @tag = params[:type]
    if @tag
      @addresses = Address.tagged_with(@tag)
    else
      @addresses = Address.all
    end
  end

end
