class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      if  ( username == "gndi" and password == "vallilatablehockeyleague" ) or ( username == "mluukkai" and password == "mluukkai" )
        session[:gndi] = true
      end
      (username == "java2100" and password == "celebration") or (username == "gndi" and password == "vallilatablehockeyleague")
    end
  end
end
