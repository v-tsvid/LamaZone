module ApplicationHelper
  def short_image_path(path)
    path.sub(Rails.root.to_s + "/public", "")
  end

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

  def flash_class(level)
    case level
      when 'notice' then "alert alert-warning"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-danger"
    end
  end
  
  private

    def current_customer_firstname
      firstname = current_customer.firstname if current_customer
      current_customer && firstname ? ", #{firstname}" : nil
    end
end
