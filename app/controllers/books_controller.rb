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
    set_book
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end
end
