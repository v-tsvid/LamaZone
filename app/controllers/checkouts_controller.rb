class CheckoutsController < ApplicationController
  include Wicked::Wizard
  include CookiesHandling
  
  WIZARD_STEPS = [:address, :shipment, :payment, :confirm, :complete]

  before_action :authenticate_customer!
  before_action :set_steps
  before_action :setup_wizard

  def create
    @order = current_order || Order.new(customer: current_customer)
    @order.prepare_for_checkout(checkout_params)
    @checkout = Checkout.new(@order)
    
    if @checkout.valid? && @checkout.save
      redirect_to checkout_path(@order.next_step.to_sym)
    else
      redirect_to root_path, alert: "Can't checkout"
    end
  end

  def show
    # find out how to extract following into the new method 
    # without control coupling
    if current_order
      @checkout = Checkout.new(current_order)
    elsif step == :complete && last_processing_order
      @checkout = Checkout.new(last_processing_order)
    end
      
    if @checkout
      redirect_if_wrong_step(@checkout.model.next_step, step) or return
      
      case step
      when :address
        @checkout.init_addresses
      when :payment
        @checkout.init_credit_card
      end
      
      render_wizard
    else
      redirect_to root_path, notice: notice_when_checkout_is_nil(step)
    end
  end  

  def update
    @checkout = Checkout.new(current_order)
    @validation_hash = set_next_step(@checkout.model, next_step.to_s)
    @validation_hash.merge!(checkout_params['model']) if WIZARD_STEPS[0..2].include?(step)
    
    case step
    when :address
      @return_hash = { 'billing_address' => @validation_hash['billing_address'], 
                       'shipping_address' => @validation_hash['shipping_address'] }

      if params['use_billing']
        @validation_hash.merge!(
          {'shipping_address' => checkout_params['model']['billing_address']})
        @return_hash['shipping_address'] = @validation_hash['billing_address']
      end
    when :shipment
      @return_hash = {
        'shipping_method' => checkout_params['model']['shipping_method'],
        'shipping_price' => checkout_params['model']['shipping_price']}
    when :payment
      @return_hash = @validation_hash['credit_card']
    when :confirm
      @validation_hash.merge!({'state' => "processing"})
      @return_hash = nil
    end
    
    redirect_if_invalid(
      @checkout, @validation_hash, @return_hash) or render_wizard(@checkout)
  end


  private
    def set_steps
      self.steps = WIZARD_STEPS
    end

    def redirect_if_wrong_step(next_step, step)
      if !next_step
        redirect_to(order_items_index_path, 
          notice: "Please checkout first") and return
      elsif next_step_next?(next_step, step)
        redirect_to(checkout_path(next_step.to_sym), 
          notice: "Please proceed checkout from this step") and return
      end
      return true
    end

    def redirect_if_invalid(checkout, validation_hash, return_hash)
      if checkout.validate(validation_hash)
        return false
      else
        redirect_to :back, {flash: { 
          errors: checkout.errors, attrs: return_hash } } 
        return true
      end 
    end
    
    # find out how to avoid the control coupling
    def notice_when_checkout_is_nil(step)
      if step == :complete
        "You have no completed orders"
      elsif step == :confirm
        "You have no orders to confirm"
      else
        "Please checkout first"
      end
    end

    def set_next_step(model, next_step)
      val_hash = model.attributes
      if next_step_next?(model.next_step, next_step)
        val_hash.merge!({next_step: next_step}) 
      end
      val_hash
    end

    def next_step_next?(prev_step, next_step)
      prev_index = Checkout::NEXT_STEPS.index(prev_step.to_sym)
      next_index = Checkout::NEXT_STEPS.index(next_step.to_sym)
      
      if !prev_index
        true
      elsif prev_index < next_index
        true
      else
        false
      end
    end

    def checkout_params
      address = [:firstname,
                 :lastname,
                 :address1,
                 :address2,
                 :phone,
                 :city,
                 :zipcode,
                 :country_id,
                 :billing_address_for_id,
                 :shipping_address_for_id]

      credit_card = [:number, 
                     :cvv, 
                     :firstname, 
                     :lastname,
                     :expiration_month, 
                     :expiration_year,
                     :customer_id]

      model = [:total_price,
               :completed_date,
               :customer_id,
               :state,
               :next_step,
               :shipping_price,
               :shipping_method,
               billing_address: address,
               shipping_address: address,
               credit_card: credit_card]

      params.require(:order).permit(
        :coupon_code,
        model: model, 
        order_items_attrs: [:book_id, :quantity])
    end
end