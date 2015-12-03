class CreateBooksCategories < ActiveRecord::Migration
  def change
    create_table :books_categories, id: false do |t|
      t.references :book_id, index: true
      t.references :category_id, index: true
    end
  end
end
