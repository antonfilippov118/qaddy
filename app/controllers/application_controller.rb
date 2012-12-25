class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def authenticate_admin_user!
    redirect_to root_url and return if signed_in? && !current_user.admin?
    redirect_to signin_url and return if !signed_in?
  end
  
  def current_admin_user
    return nil if signed_in? && !current_user.admin?
    current_user
  end

end
