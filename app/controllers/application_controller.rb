# encoding: UTF-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_json data
    render json: data
  end
end
