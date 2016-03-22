class Author < ActiveRecord::Base
  validates :firstname, :lastname, presence: true
  
  has_many :books

  rails_admin do
    object_label_method do
      :custom_label_method
    end
  end

  def full_name
    "#{self.firstname} #{self.lastname}"
  end

  private

    def custom_label_method
      "#{self.lastname} #{self.firstname}"
    end
end
