class Author < ActiveRecord::Base
  validates :firstname, :lastname, presence: true
  
  has_many :books
end
