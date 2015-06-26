class Author < ActiveRecord::Base
  validates :firstname, :lastname, presense: true
  
  has_many :books
end
