# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :admin? # be able to use the admin? method as a helper in views

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  protected
  
  # Check if the current user is admin
  def admin?
    session[:admin] == true
  end
  
  # Check the user has been identified as admin, or redirect to login
  def admin_required
    if admin?
      true
    else
      flash[:error] = "Estás intentando acceder a una zona privada"
      save_referer
      redirect_to '/login'
      false
    end
  end
  
  def sort_order(default,order_as)
    "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{((params[:d] || order_as) == 'down' ? 'DESC' : 'ASC')}"
  end

  
  private
  
  def save_referer
    unless session[:return_to]
      session[:return_to] = request.request_uri || feeds_path
    end
  end
  
end
