#encoding: UTF-8
class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception
 
  def redirect_to_back(default = root_url)
    if !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to default
    end
  end

  # Before filters
  def signed_in_session
    redirect_to signin_url unless signed_in?
  end
end
