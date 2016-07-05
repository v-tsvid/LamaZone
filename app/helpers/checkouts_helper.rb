module CheckoutsHelper
  def order_summary_cols_hash(item)
    coupon = item.coupon

    {"#{t("checkout.order.subtotal")}: " => 
     "#{PriceDecorator.new(item.subtotal).decorate}",

     "#{t("checkout.order.discount")}: " => 
     "#{coupon ? coupon.discount : 0}%",

     "#{t("checkout.order.shipping")}: " => 
     "#{PriceDecorator.new(item.shipping_price).decorate}",

     "#{t("checkout.order.total")}: " => 
     "#{PriceDecorator.new(item.total_price).decorate}"}
  end

  def shipping_method_checked?(method, current_method)
    method == current_method || 
    current_method && method == Order::SHIPPING_METHOD_LIST[0]
  end

  def link_inaccessible?(next_step, item)
    next_step_sym = next_step.to_sym
    next_steps = CheckoutForm::NEXT_STEPS

    next_steps.index(next_step_sym) < next_steps.index(item) || 
    (next_step_sym == :complete && item != :complete)
  end

  def addresses_is_equal?(billing_address, shipping_address)
    billing_address && shipping_address && 
    billing_address.attributes_short == shipping_address.attributes_short && 
    !flash[:errors]
  end
end