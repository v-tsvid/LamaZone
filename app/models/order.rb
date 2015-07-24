class Order < ActiveRecord::Base
  DATE_COMPLETE_BEFORE_CREATE_MESSAGE = "can't be before created date"

  validates :total_price, :completed_date, :state, presence: true
  validates :total_price, numericality: { greater_than: 0 }
  
  #provided by validates_timeliness gem
  #validates value as date
  validates_date :completed_date
  validate :date_completed_before_created

  belongs_to :customer
  belongs_to :credit_card
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  has_many :order_items

  scope :in_progress, -> { where(state: 0) }

  before_create :state_to_default

  private

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

    def state_to_default
      self.state = 0
    end
end
