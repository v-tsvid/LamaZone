class BooksController < ApplicationController
  load_and_authorize_resource

  def index
    @categories = Category.all
    @books = @books.page(params[:page]).per(6)
  end

  def show
  end
end
