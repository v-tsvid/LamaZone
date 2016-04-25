class BooksController < ApplicationController
  load_and_authorize_resource

  # GET /books
  # GET /books.json
  def index
    @categories = Category.all
    @books = @books.page(params[:page]).per(6)
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end
end
