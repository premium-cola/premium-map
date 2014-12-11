# encoding: UTF-8

class UploadsController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def upload
    flash[:notice] = "Datei hochgeladen"
    if (File.extname(params[:excel_file].original_filename) != ".xls" or params[:excel_file].content_type == "text/csv")
      Address.parse_csv(params[:excel_file].tempfile)
    else
      Address.parse_excel(params[:excel_file].tempfile)
    end

    redirect_to addresses_path
  end
end
