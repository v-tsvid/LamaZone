module CheckoutRedirecting
  extend ActiveSupport::Concern
  
  private
    def redirect_if_wrong_step(checkout_form, step)
      order_next_step = checkout_form.model.next_step
      notice = wrong_step_notice(order_next_step, step)
      
      if notice
        redirect_to(
          checkout_path(order_next_step.to_sym), notice: notice) or return
      end
    end

    def wrong_step_notice(order_next_step, current_step)
      if is_completed_order?(order_next_step, current_step) 
        t("checkout.recent_completed_order")
      elsif is_wrong_step?(order_next_step, current_step)
        t("checkout.proceed_from_step")
      else
        nil
      end
    end

    def notice_when_checkout_is_nil(step)
      case step
      when :complete then t("checkout.no_completed_orders")
      when :confirm then t("checkout.no_orders_to_confirm")
      else t("checkout.checkout_first")
      end
    end

    def is_wrong_step?(order_next_step, current_step)
      is_next?(order_next_step, current_step)
    end

    def is_completed_order?(order_next_step, current_step)
      order_next_step == 'complete' && current_step != :complete
    end

    def is_next?(prev_step, next_step)
      prev_index = steps.index(prev_step.to_sym) if prev_step
      next_index = steps.index(next_step.to_sym) if next_step
      
      !prev_index || prev_index < next_index
    end

end