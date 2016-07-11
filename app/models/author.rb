class Author < ActiveRecord::Base

  validates :firstname, :lastname, presence: true
  
  has_many :books

  def custom_label_method
    PersonDecorator.decorate(self).full_name
  end    
end
