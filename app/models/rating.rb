class Rating < ActiveRecord::Base
  include AASM

  STATE_LIST = ['pending', 'rejected', 'approved']

  validates :state, presence: true
  validates :rate, numericality: { only_integer: true, 
    greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :state, inclusion: { in: STATE_LIST }
    
  belongs_to :customer
  belongs_to :book

  aasm column: 'state', whiny_transitions: false do 
    state :pending, initial: true
    state :rejected
    state :approved
  end

  rails_admin do
    object_label_method do
      :custom_label_method
    end
  end

  def state_enum
    STATE_LIST
  end

  private

    def custom_label_method
      "rating #{self.id} for book #{self.book_id}"
    end
end
