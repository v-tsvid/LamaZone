class RenameColumnImageInBooksToImages < ActiveRecord::Migration
  def change
    rename_column :books, :image, :images
  end
end
