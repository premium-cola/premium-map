# encoding: UTF-8

class AddressesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @addresses = Address.paginate(:page => params[:page], :per_page => 20).order('city, company, last_name, first_name')
  end

end
