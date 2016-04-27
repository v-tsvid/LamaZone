class Checkout < Reform::Form
  extend ::ActiveModel::Callbacks
  require 'price_calculator'
  include PriceCalculator

  NEXT_STEPS = [:address, :shipment, :payment, :confirm, :complete]

  model :order
  
  define_model_callbacks :validation

  before_validation :update_shipping_price
  before_validation :update_subtotal
  before_validation :update_total_price
  
  property :total_price
  property :completed_date
  property :state
  property :customer
  property :next_step
  property :shipping_method
  property :shipping_price
  property :subtotal

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

  property :billing_address, populate_if_empty: Address, form: BillingAddress 
  property :shipping_address, populate_if_empty: Address, form: ShippingAddress

  property :credit_card, populate_if_empty: CreditCard do
    VALID_EXP_MONTH_REGEX = /\A([0][1-9]|[1][0-2])\z/
    VALID_EXP_YEAR_REGEX = /\A[2][0]([1][5-9]|[2][0-9])\z/
    VALID_CVV_REGEX = /\A[0-9]{3,4}\z/

    INVALID_MESSAGE = "is not valid"
    EXPIRED_MESSAGE = "is expired"

    property :firstname
    property :lastname
    property :number
    property :cvv
    property :expiration_month
    property :expiration_year
    property :customer_id

    validates :number, 
              :cvv, 
              :firstname, 
              :lastname,
              :expiration_month, 
              :expiration_year, 
              :customer_id,
              presence: true

    validates :expiration_month, format: { with: VALID_EXP_MONTH_REGEX, 
      message: INVALID_MESSAGE }
    validates :expiration_year, format: { with: VALID_EXP_YEAR_REGEX, 
      message: INVALID_MESSAGE }
    validates :cvv, format: { with: VALID_CVV_REGEX, message: INVALID_MESSAGE }

    validate :validate_number, :validate_exp_date

    private

      def validate_number
        # CreditCardValidator::Validator.valid? 
        # is provided by credit_card_validator gem
        errors.add(:credit_card, INVALID_MESSAGE) unless 
          self.number && CreditCardValidator::Validator.valid?(self.number)
      end

      def validate_exp_date
        errors[:base] << EXPIRED_MESSAGE unless 
          self.expiration_month && self.expiration_year && 
          (self.expiration_year > Date.today.strftime("%Y") || 
            self.expiration_year == Date.today.strftime("%Y") &&
            self.expiration_month >= Date.today.strftime("%m"))
      end
  end

  property :coupon, populate_if_empty: Coupon do
    property :code
    property :discount

    validates :code, :discount, presence: true
    validates :discount, inclusion: { in: 1..99 }
  end
  

  validates :subtotal,
            :total_price, 
            :customer,  
            :state, 
            :next_step, 
            presence: true
  
  validates(:subtotal, :total_price, numericality: { greater_than: 0 }, 
    unless: :next_step_address?)

  validates(:credit_card, presence: true, 
    if: :next_step_confirm_or_complete?)

  validates(:billing_address, :shipping_address, presence: true, 
    unless: :next_step_address?)

  validates(:shipping_method, inclusion: { in: SHIPPING_METHOD_LIST },
    unless: :next_step_address_or_shipment?)
  validates(:shipping_price, numericality: { greater_than_or_equal: 0 },
    unless: :next_step_address_or_shipment?)

  validates :order_items, presence: true
  validates :state, inclusion: { in: Order::STATE_LIST }
  
  # provided by validates_timeliness gem
  # validates value as a date
  validates :completed_date, timeliness: {type: :date}, allow_blank: true
  

  def persisted?
    false
  end

  def save
    super
    model.save!
  end

  def valid?
    run_callbacks :validation do
      super
    end
  end

  private

    def next_step_confirm_or_complete?
      self.next_step == 'confirm' || self.next_step == 'complete'
    end

    def next_step_address_or_shipment?
      next_step_address? || next_step_shipment?
    end

    def next_step_address?
      self.next_step == 'address'
    end

    def next_step_shipment?
      self.next_step == 'shipment'
    end
end