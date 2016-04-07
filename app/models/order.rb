class Order < ActiveRecord::Base
  include AASM

  STATE_LIST = ["in_progress", 
                "processing", 
                "shipping", 
                "completed", 
                "canceled"]

  SHIPPING_METHOD_LIST = ["UPS Ground", 
                          "UPS One Day", 
                          "UPS Two Days"]

  belongs_to :customer
  belongs_to :credit_card
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  belongs_to :coupon
  has_many :order_items

  before_validation :update_shipping_price
  before_validation :update_subtotal
  before_validation :update_total_price

  validates_associated :order_items

  aasm column: 'state', whiny_transitions: false do 
    state :in_progress, initial: true
    state :processing
    state :shipping 
    state :completed 
    state :canceled

    event :cancel do
      transitions from: [:in_progress, :processing], to: :canceled
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

  def calc_total_price
    (self.subtotal / 100 * (100 - (self.coupon ? self.coupon.discount : 0)) + self.shipping_price)
  end

  private

    

    def update_subtotal
      self.subtotal = self.order_items.collect { |item| (item.quantity * item.price) }.sum
    end

    def update_total_price
      self.total_price = self.calc_total_price
    end

    def update_shipping_price
      self.shipping_price = self.calc_shipping_price(self.shipping_method)
    end

    def custom_label_method
      "#{self.id}"
    end
end
