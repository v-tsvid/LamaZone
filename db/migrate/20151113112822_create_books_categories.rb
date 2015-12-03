class CreateBooksCategories < ActiveRecord::Migration
  def change
    create_table :books_categories, id: false do |t|
      t.integer :book_id, index: true, foreign_key: true
      t.integer :category_id, index: true, foreign_key: true
    end
  end
end
