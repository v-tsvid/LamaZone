module ApplicationHelper
  def resource_name
    :customer
  end

  def resource
    @resource ||= Customer.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:customer]
  end

  def hello_customer
    "#{t :hello}#{current_customer_firstname}! #{t :in_lamazone}"
  end

  def cart_caption
    (current_order || order_from_cookies).decorate.cart_caption
  end
  
  private

    def current_customer_firstname
      firstname = current_customer.firstname if current_customer
      current_customer && firstname ? ", #{firstname}" : nil
    end
end
