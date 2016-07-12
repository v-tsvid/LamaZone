module CheckoutsHelper
  
  def shipping_method_checked?(method, current_method)
    method == current_method || 
    !current_method && method == Order::SHIPPING_METHOD_LIST[0]
  end

  def link_inaccessible?(next_step, item)
    next_step_sym = next_step.to_sym
    next_steps = CheckoutForm::NEXT_STEPS

    next_steps.index(next_step_sym) < next_steps.index(item) || 
    (next_step_sym == :complete && item != :complete)
  end
end