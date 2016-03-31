class Checkout < Reform::Form

  extend ::ActiveModel::Callbacks

  model :order
  
  define_model_callbacks :validation

  before_validation :update_shipping_price
  before_validation :update_total_price
  

  property :total_price
  property :completed_date
  property :state
  property :customer
  property :credit_card
  property :next_step
  property :shipping_method
  property :shipping_price

  property :billing_address, populate_if_empty: Address do
    property :firstname
    property :lastname
    property :address1
    property :address2
    property :phone
    property :city
    property :zipcode
    property :country_id
    property :billing_address_for_id
    property :shipping_address_for_id

    validates :firstname,
              :lastname,
              :address1,
              :phone,
              :city,
              :zipcode,
              :country_id,
              presence: true

    # provided by phony_rails gem
    # validates phone number to be correct and plausible 
    # without country accordance
    validates :phone, phony_plausible: { ignore_record_country_code: true }
    
    # provided by validates_zipcode gem
    # validates zipcode to be correct due to country alpha2 code
    validates :zipcode, zipcode: { country_code: :country_code }
  end

  property :shipping_address, populate_if_empty: Address do
    property :firstname
    property :lastname
    property :address1
    property :address2
    property :phone
    property :city
    property :zipcode
    property :country_id
    property :billing_address_for_id
    property :shipping_address_for_id

    validates :firstname,
              :lastname,
              :address1,
              :phone,
              :city,
              :zipcode,
              :country_id,
              presence: true

    # provided by phony_rails gem
    # validates phone number to be correct and plausible 
    # without country accordance
    validates :phone, phony_plausible: { ignore_record_country_code: true }
    
    # provided by validates_zipcode gem
    # validates zipcode to be correct due to country alpha2 code
    validates :zipcode, zipcode: { country_code: :country_code }
  end

  collection :order_items, populate_if_empty: OrderItem do
    property :price
    property :quantity
    property :book 
    property :order

    validates :price, :quantity, :book, presence: true
    validates :order, presence: true
    validates :price, numericality: { greater_than: 0 }
    validates :quantity, numericality: { only_integer: true,
                                         greater_than: 0 }
  end

  validates :total_price, 
            :customer,  
            :state, 
            :next_step, 
            presence: true
  
  validates(:total_price, numericality: { greater_than: 0 }, 
    unless: :next_step_address?)

  validates(:credit_card, presence: true, 
    unless: Proc.new { :next_step_address? || :next_step_shipping? })

  validates(:billing_address, :shipping_address, presence: true, 
    unless: :next_step_address?)

  validates(:shipping_method, inclusion: { in: Order::SHIPPING_METHOD_LIST },
    if: :next_step_confirm_or_complete?)

  
  validates :shipping_price, numericality: { greater_than_or_equal: 0 }
  validates :order_items, presence: true
  validates :state, inclusion: { in: Order::STATE_LIST }
  
  # provided by validates_timeliness gem
  # validates value as a date
  validates :completed_date, timeliness: {type: :date}, allow_blank: true
  

  def persisted?
    false
  end

  # def save
  #   super
  #   model.save!
  # end

  def save
    super
    model.save!
  end

  def valid?
    run_callbacks :validation do
      super
    end
  end

  def calc_shipping_price(method)
    case method
    when Order::SHIPPING_METHOD_LIST[0]
      5.00
    when Order::SHIPPING_METHOD_LIST[1]
      15.00
    when Order::SHIPPING_METHOD_LIST[2]
      10.00
    when nil
      0
    end
  end

  private
    def update_total_price
      self.total_price = self.order_items.collect { |item| (item.quantity * item.price) }.sum
    end

    def update_shipping_price
      self.shipping_price = self.calc_shipping_price(self.shipping_method)
    end 

    def next_step_confirm_or_complete?
      self.next_step == 'confirm' || self.next_step == 'complete'
    end

    def next_step_address_or_shipping?
      next_step_address? || next_step_shipping?
    end

    def next_step_address?
      self.next_step == 'address'
    end

    def next_step_shipping?
      self.next_step == 'shipping'
    end
end