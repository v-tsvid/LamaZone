class Order < ActiveRecord::Base
  include AASM

  STATE_LIST = ["in_progress", 
                "processing", 
                "shipping", 
                "completed", 
                "canceled"]
  
  DATE_COMPLETE_BEFORE_CREATE_MESSAGE = "can't be before created date"

  # before_save :total_price

  validates :total_price, :state, presence: true
  validates :total_price, numericality: { greater_than: 0 }
  validates :state, inclusion: { in: STATE_LIST }
  #provided by validates_timeliness gem
  #validates value as a date
  validates_date :completed_date, allow_blank: true
 
  belongs_to :customer
  belongs_to :credit_card
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  has_many :order_items

  before_validation :update_total_price

  scope :in_progress, -> { where(state: 'in_progress') }

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

  # def total_price
  #   order_items.collect { |item| (item.quantity * item.price) }.sum
  # end

  private 

    def update_total_price
      self.total_price = self.order_items.collect { |item| (item.quantity * item.price) }.sum
    end

    def custom_label_method
      "#{self.id}"
    end
end
