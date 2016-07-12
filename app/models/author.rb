class Author < ActiveRecord::Base
  include PersonMethods

  validates :firstname, :lastname, presence: true
  
  has_many :books    
end
