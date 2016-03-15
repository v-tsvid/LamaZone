class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  alias_method :current_user, :current_customer

  helper_method :current_order

  def current_order
    # cookies[:order_items] = Array.new
    cookies[:order] ||= JSON.generate(Order.new.attributes)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :firstname << :lastname
  end

  # def current_ability
  #   @current_ability ||= Ability.new(current_customer)
  # end
end
