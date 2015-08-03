class Book < ActiveRecord::Base
  validates :title, :price, :books_in_stock, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :books_in_stock, numericality: 
    { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :author
  belongs_to :category
  has_many :ratings

  mount_uploader :images, BookImageUploader
  # attr_accessible :asset, :asset_cache, :remove_asset
end
