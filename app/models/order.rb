class Order < ActiveRecord::Base
  include AASM
  include PriceCalculator

  STATE_LIST = ["in_progress", 
                "processing", 
                "shipping", 
                "completed", 
                "canceled"]

  belongs_to :customer
  belongs_to :credit_card
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  belongs_to :coupon
  has_many :order_items, dependent: :delete_all

  aasm column: 'state', whiny_transitions: false do 
    state :in_progress, initial: true
    state :processing
    state :shipping 
    state :completed 
    state :canceled

    event :cancel do
      transitions from: [:processing], to: :canceled
    end
  end

  class << self
    def create_customers_order(customer)
      customer ? Order.create(customer: customer, state: 'in_progress') : nil
    end
  end

  def state_enum
    STATE_LIST
  end

  rails_admin do
    object_label_method do
      :custom_label_method
    end
  end

  def for_checkout(checkout_params)
    return false unless self.init_with_order_items(
      checkout_params[:order_items_attrs])
    
    coupon = Coupon.find_by(code: checkout_params[:coupon_code])
    next_step = self.next_step || 'address'

    self.update(coupon: coupon, next_step: next_step)
    self
  end

  def init_with_order_items(items_params)
    if items_params
      order_items = items_params.map do |item|
        OrderItem.new({book_id: item['book_id'], quantity: item['quantity']})
      end
    else
      order_items = Array.new
    end
  
    self.order_items.destroy_all
    self.order_items = order_items
  end

  private

    def custom_label_method
      "#{self.id}"
    end
end
