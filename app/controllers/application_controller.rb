class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #require 'kitco'

  @account_active == true;

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)

  	if current_user.role == 'admin'
  		adminview_admin_administrator_path(current_user, format: :html)
  	else
  		accounts_path(current_user, format: :html)
  	end
  end
  # def after_sign_up_path_for(resource)
  #   new_user_customers_path(current_user)
  # end
  helper_method :admin?
  helper_method :my_customer

  protected
  	def configure_permitted_parameters
	    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
	    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
	    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  	end

    def admin?
     current_user.role == "admin"
    end
    
    def my_customer
     Customer.find_by_user_id(current_user.id)
    end

   #def kitco
   # @gold = Kitco.gold
   # @silver = Kitco.silver
   # @platinum = Kitco.platinum
   # @palladium = Kitco.palladium
   # @rhodium = Kitco.rhodium
   #end
   def getaddrinfo_tmp
     logger.error "Failed to open TCP connection to charts.kitco.com:80"
     #notice: 'Failed to connect to charts.kitco.com'
   end
end
