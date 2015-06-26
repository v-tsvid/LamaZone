class Book < ActiveRecord::Base
  validates :title, :price, :books_in_stock, presence: true

  belongs_to :author
  belongs_to :category
  has_many :ratings
end
