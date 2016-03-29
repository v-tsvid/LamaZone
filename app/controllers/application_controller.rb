class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  alias_method :current_user, :current_customer

  helper_method :current_order

  def current_order
    current_customer ? current_customer.current_order : nil
  end

  def compact_order_items(order_items)
    order_items = order_items.group_by{|h| h.book_id}.values.map do |a| 
      OrderItem.new(book_id: a.first.book_id, 
                    quantity: a.inject(0){|sum,h| sum + h.quantity})
    end

    order_items.each do |item| 
      item.price = Book.find(item.book_id).price * item.quantity
    end

    order_items
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :firstname << :lastname
  end

  # def current_ability
  #   @current_ability ||= Ability.new(current_customer)
  # end
end
