class Rating < ActiveRecord::Base
  validates :rate, numericality: { only_integer: true, 
    greater_than: 0, less_than: 11 }
    
  belongs_to :customer
  belongs_to :book
end
