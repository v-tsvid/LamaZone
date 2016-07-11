class Rating < ActiveRecord::Base
  include AASM

  STATE_LIST = ['pending', 'rejected', 'approved']

  validates :state, presence: true, inclusion: { in: STATE_LIST }
  validates :rate, numericality: { allow_blank: true, only_integer: true, 
    greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
    
  belongs_to :customer
  belongs_to :book

  aasm column: 'state', whiny_transitions: false do 
    state :pending, initial: true
    state :rejected
    state :approved
  end

  def custom_label_method
    "rating #{self.id} for book #{self.book_id}"
  end

  def state_enum
    STATE_LIST
  end
end
