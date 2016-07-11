class StaticPagesController < ApplicationController
  def home
    @books = Book.of_category('bestsellers')
  end
end
