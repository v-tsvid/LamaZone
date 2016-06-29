class HashInitializer

  attr_accessor :validation_hash
  attr_accessor :return_hash

  attr_accessor :steps
  attr_accessor :is_next

  def initialize(model, params, steps, step, next_step, is_next)
    self.steps = steps
    self.is_next = is_next
    self.validation_hash = set_next_step(model, next_step.to_s)
    self.validation_hash.merge!(params['model']) if self.steps[0..2].include?(step)
    
    case step
    when :address
      self.return_hash = { 
        'billing_address' => self.validation_hash['billing_address'], 
        'shipping_address' => self.validation_hash['shipping_address'] }

      if params['use_billing']
        self.validation_hash.merge!(
          {'shipping_address' => params['model']['billing_address']})
        self.return_hash['shipping_address'] = self.validation_hash['billing_address']
      end
    when :shipment
      self.return_hash = {
        'shipping_method' => params['model']['shipping_method'],
        'shipping_price' => params['model']['shipping_price']}
    when :payment
      self.return_hash = self.validation_hash['credit_card']
    when :confirm
      self.validation_hash.merge!({'state' => "processing"})
      self.return_hash = nil
    end
  end

  private
    def set_next_step(model, next_step)
      val_hash = model.attributes
      val_hash.merge!({next_step: next_step}) if is_next
      val_hash
    end
end