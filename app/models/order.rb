class Order < ActiveRecord::Base
  include AASM

  STATE_LIST = ["in_progress", 
                "in_queue", 
                "in_delivery", 
                "delivered", 
                "canceled"]
  
  DATE_COMPLETE_BEFORE_CREATE_MESSAGE = "can't be before created date"

  validates :total_price, :completed_date, :state, presence: true
  validates :total_price, numericality: { greater_than: 0 }
  validates :state, inclusion: { in: STATE_LIST }
  #provided by validates_timeliness gem
  #validates value as date
  validates_date :completed_date
  validate :date_completed_before_created

  belongs_to :customer
  belongs_to :credit_card
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  has_many :order_items

  scope :in_progress, -> { where(state: 'in_progress') }

  aasm column: 'state', whiny_transitions: false do 
    state :in_progress, initial: true
    state :in_queue
    state :in_delivery 
    state :delivered 
    state :canceled

    event :cancel do
      transitions from: [:in_progress, :in_queue], to: :canceled
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

  private

    def custom_label_method
      "#{self.id}"
    end

    def date_completed_before_created
      errors.add(:completed_date, DATE_COMPLETE_BEFORE_CREATE_MESSAGE) unless 
        self.completed_date && self.created_at &&
        self.completed_date >= self.created_at
    end

    def add_book(book)
      item = self.order_items.find_by(book_id: book.id)
      if item
        item.quantity += 1
      else
        item = self.order_items.new(book_id: book.id, 
                                    order_id: self.id, 
                                    quantity: 1, 
                                    price: Book.find(book.id).price)
      end
      item.save
    end 
end
