# encoding: UTF-8

class MapsController < ApplicationController
  before_filter :authenticate_user!, :except => [:embed]

  def embed
    render layout: nil
  end
end
