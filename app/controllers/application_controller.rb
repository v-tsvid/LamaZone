  class ApplicationController < ActionController::Base

  include CookiesHandling
  include OrderHelpers
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  after_filter :store_location

  alias_method :current_user, :current_customer

  helper_method :current_order, 
                :order_from_cookies, 
                :flash_class

  rescue_from ActionController::RoutingError do
    redirect_to root_path, alert: t("controllers.no_page")
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

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

  def flash_class(level)
    case level
      when 'notice' then "alert alert-warning"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-danger"
    end
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :firstname << :lastname
    end

  private

    def store_location
      # store last url - this is needed for post-login redirect 
      # to whatever the customer last visited.
      return unless request.get? 
      if (path_not_equal("/customers/sign_in") &&
          path_not_equal("/customers/sign_up") &&
          path_not_equal("/customers/password/new") &&
          path_not_equal("/customers/password/edit") &&
          path_not_equal("/customers/confirmation") &&
          path_not_equal("/customers/sign_out") &&
          !request.xhr?) # don't store ajax calls
        session[:previous_url] = request.fullpath 
      end
    end

    def path_not_equal(path)
      request.path != path
    end

    def after_sign_in_path_for(resource)
      prev_url = session[:previous_url]
      prev_url == cart_path ? prev_url || root_path : super
    end

    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
end
