class CheckoutValidationHashForm
  
  attr_accessor :validation_hash
  attr_accessor :return_hash
  
  def initialize(model, params, steps, step, next_step, is_next)
    self.model = model
    self.params = params
    self.steps = steps
    self.step = step
    self.next_step = next_step
    self.is_next = is_next
    
    self.validation_hash = init_validation_hash
    self.return_hash = init_return_hash
  end

  private

    attr_accessor :model
    attr_accessor :params
    attr_accessor :steps
    attr_accessor :step
    attr_accessor :next_step
    attr_accessor :is_next

    def init_validation_hash
      val_hash_initial.merge(val_hash_with_step)
    end

    def val_hash_initial
      if steps[0..2].include?(step)
        set_next_step.merge(params['model']) 
      else
        set_next_step
      end
    end

    def val_hash_with_step
      case step
      when :address then address_for_val_hash
      when :confirm then {'state' => "processing"}
      else {}
      end
    end

    def address_for_val_hash
      if params['use_billing']
        {'shipping_address' => params['model']['billing_address']} 
      else
        {}
      end
    end

    def init_return_hash
      case step
      when :address then addresses_for_return_hash
      when :shipment then shipping_for_return_hash
      when :payment then validation_hash['credit_card']
      else {}
      end
    end

    def addresses_for_return_hash
      addr = params['use_billing'] ? 'billing_address' : 'shipping_address'
      { 'billing_address' => validation_hash['billing_address'], 
        'shipping_address' => validation_hash[addr] }
    end

    def shipping_for_return_hash
      { 'shipping_method' => params['model']['shipping_method'],
        'shipping_price' => params['model']['shipping_price']} 
    end

    def set_next_step
      val_hash = model.attributes
      val_hash.merge!({next_step: next_step.to_s}) if is_next
      val_hash
    end
end