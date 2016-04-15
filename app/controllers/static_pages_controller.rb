class StaticPagesController < ApplicationController
  def home
    @books = Book.books_of_category('bestsellers')
  end
end
