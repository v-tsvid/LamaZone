class ApplicationController < ActionController::Base

  include CookiesHandling
  include OrderHelpers
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  PATHS = ["/customers/sign_in", 
           "/customers/sign_up", 
           "/customers/password/new", 
           "/customers/password/edit",
           "/customers/confirmation",
           "/customers/sign_out"]

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  after_filter :store_location

  rescue_from ActionController::RoutingError, with: :handle_routing_error
  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  alias_method :current_user, :current_customer

  helper_method :current_order, 
                :order_from_cookies

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def set_locale
    I18n.locale = params[:locale] || 
    session[:omniauth_login_locale] || 
    I18n.default_locale

    session[:omniauth_login_locale] = I18n.locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :firstname << :lastname
    end

  private

    def handle_access_denied(exception)
      redirect_to root_path, alert: exception.message
    end

    def handle_routing_error
      redirect_to root_path, alert: t("controllers.no_page")
    end

    def store_location
      # store last url - this is needed for post-login redirect 
      # to whatever the customer last visited.
      session[:previous_url] = request.fullpath if last_url_to_store?
    end

    def last_url_to_store?
       request.get? && !request.xhr? && !PATHS.include?(request.path)
    end

    def after_sign_in_path_for(resource)
      prev_url = session[:previous_url]
      prev_url == cart_path ? cart_path : super
    end

    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
end
