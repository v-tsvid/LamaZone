class Book < ActiveRecord::Base
  validates :title, :price, :books_in_stock, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :books_in_stock, numericality: 
    { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :author
  has_and_belongs_to_many :categories #, join_table: :books_categories
  has_many :ratings, dependent: :delete_all

  mount_uploader :images, BookImageUploader
  # attr_accessible :asset, :asset_cache, :remove_asset

  private

    def self.of_category(title)
      category = Category.find_by_title(title)
      category ? category.books : all
    end
end
