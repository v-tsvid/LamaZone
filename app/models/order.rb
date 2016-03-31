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
  has_many :order_items

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
    when SHIPPING_METHOD_LIST[0]
      5.00
    when SHIPPING_METHOD_LIST[1]
      15.00
    when SHIPPING_METHOD_LIST[2]
      10.00
    when nil
      0
    end
  end

  private

    def custom_label_method
      "#{self.id}"
    end
end
