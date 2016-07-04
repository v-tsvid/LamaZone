class RatingsController < ApplicationController
  before_action :authenticate_customer!, except: [:index, :show]
  
  skip_load_resource only: [:new]
  load_and_authorize_resource

  def new
    @book = Book.find_by_id(params[:book_id])
    @rating = Rating.new(book: @book, customer: current_customer)
  end

  def create
    @book = Book.find_by_id(params[:book_id])
    @rating = Rating.new(rating_params)
    @rating.customer = current_customer

    if @rating.save
      redirect_to book_path(@book), notice: t("controllers.rating_created") 
    else
      render :new 
    end
  end

  private

    def rating_params
      params.require(:rating).permit(:id, :rate, :review, :book_id)
    end
end
