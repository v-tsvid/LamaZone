class Checkout < Reform::Form

  model :order

  property :total_price
  property :completed_date
  property :state
  property :customer
  property :credit_card
  property :next_step

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

  collection :order_items do
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
  
  validates :total_price, numericality: { greater_than: 0 }, unless: :on_address_step?
  validates :credit_card, presence: true, unless: Proc.new { :on_address_step? || :on_delivery_step? }
  validates :billing_address, :shipping_address, presence: true, unless: :on_address_step?
  validates :order_items, presence: true
  validates :completed_date, timeliness: {type: :date}, allow_blank: true

  

  def persisted?
    false
  end

  def save
    super
    model.save!
  end

  private

  # def persist!

  #   # order_items.each do |item|
  #   #   OrderItem.create!(item)
  #   # end

  #   @order = Order.create!(
  #     total_price: total_price,
  #     completed_date: completed_date,
  #     customer: customer,
  #     credit_card: credit_card,
  #     shipping_address: shipping_address,
  #     billing_address: billing_address,
  #     state: state,
  #     next_step: next_step,
  #     order_items: order_items)

  #   # @order_items = Array.new


  #   # @order.order_items << order_items

  #   @order.save!

  # end

  def on_address_step?
    self.next_step == 'address'
  end

  def on_delivery_step?
    self.next_step == 'delivery'
  end
end