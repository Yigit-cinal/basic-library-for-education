class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  private
  
  def current_admin
    session[:admin_logged_in]
  end
  
  def admin_logged_in?
    !!session[:admin_logged_in]
  end
  
  helper_method :admin_logged_in?
end