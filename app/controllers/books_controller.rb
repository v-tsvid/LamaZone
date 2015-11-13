class BooksController < ApplicationController

  load_and_authorize_resource

  # GET /books
  # GET /books.json
  def index
  end

  # GET /books/1
  # GET /books/1.json
  def show
    set_book
  end

  # DELETE /books/1
  # DELETE /books/1.json

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end
end
