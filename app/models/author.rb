class Author < ActiveRecord::Base
  include Person

  validates :firstname, :lastname, presence: true
  
  has_many :books

  rails_admin do
    object_label_method do
      :custom_label_method
    end
  end

  private

    def custom_label_method
      "#{self.lastname} #{self.firstname}"
    end
end
