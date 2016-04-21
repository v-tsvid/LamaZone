class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  after_filter :store_location

  alias_method :current_user, :current_customer

  helper_method :current_order, 
                :cart_subtotal, 
                :cart_total_quantity, 
                :cool_id, 
                :cool_card_number,
                :cool_price,
                :cool_date,
                :flash_class

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
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

  def cool_date(date)
    "#{date.strftime("%B %d, %Y")}"
  end

  def cool_price(price)
    "$#{'%.2f' % price}"
  end

  def cool_card_number(number)
    "**** **** **** #{number.split("").last(4).join("")}"
  end

  def cool_id(id)
    "%07d" % id
  end

  def cart_subtotal
    if current_order
      current_order.send(:update_subtotal)
    else
      @order = Order.new
      @order.order_items = read_from_cookies
      @order.order_items.each { |item| item.send(:update_price)}
      @order.send(:update_subtotal)
    end
  end

  def cart_total_quantity
    if current_order
      current_order.order_items.collect { |item| item.quantity }.sum
    else
      @order = Order.new
      @order.order_items = read_from_cookies
      @order.order_items.collect { |item| item.quantity }.sum
    end
  end

  def read_from_cookies
    order_items = Array.new
    if cookies[:order_items]
      cookies[:order_items].split(' ').
        partition.with_index{ |v, index| index.even? }.transpose.each do |item|
          order_items << OrderItem.new(book_id: item[0], quantity: item[1])
      end
    end
    order_items
  end

  def current_order
    current_customer ? current_customer.current_order : nil
  end

  def last_processing_order
    if current_order
      nil
    else
      current_customer ? Order.where(
        customer: current_customer, state: 'processing').last : nil
    end
  end

  def compact_order_items(order_items)
    order_items = order_items.group_by{|h| h.book_id}.values.map do |a| 
      OrderItem.new(book_id: a.first.book_id, 
                    quantity: a.inject(0){|sum,h| sum + h.quantity})
    end

    order_items.each do |item| 
      item.price = item.book.price
    end

    order_items
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :firstname << :lastname
    end

  private

    def store_location
      # store last url - this is needed for post-login redirect to whatever the customer last visited.
      return unless request.get? 
      if (request.path != "/customers/sign_in" &&
          request.path != "/customers/sign_up" &&
          request.path != "/customers/password/new" &&
          request.path != "/customers/password/edit" &&
          request.path != "/customers/confirmation" &&
          request.path != "/customers/sign_out" &&
          !request.xhr?) # don't store ajax calls
        session[:previous_url] = request.fullpath 
      end
    end

    def after_sign_in_path_for(resource)
      if session[:previous_url] == order_items_index_path
        session[:previous_url] || root_path 
      else
        super
      end
    end
end
