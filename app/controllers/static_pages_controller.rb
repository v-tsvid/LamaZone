class StaticPagesController < ApplicationController
  def home
    @books = Book.books_of_category('bestsellers')
  end

  # def cart
  #   @cart_items = JSON.parse cookies[:order_items]
  # end
end
