class CreateBooksCategories < ActiveRecord::Migration
  def change
    create_table :books_categories, id: false do |t|
      t.references :book, index: true
      t.references :category, index: true
    end
  end
end
