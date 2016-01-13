class RatingsController < ApplicationController

  NOTICE_CREATE_SUCCESS = 'Rating was successfully created. '\
                          'It will be available soon'
  NOTICE_UPDATE_SUCCESS = 'Rating was successfully updated. '\
                          'It will be available soon'
  NOTICE_DESTROY_SUCCESS = 'Rating was successfully destroyed.'

  before_action :authenticate_customer!, except: [:index, :show]
  # before_action :authenticate_customer_if_exists, only: [:index]
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  
  skip_load_resource only: [:index, :new]
  load_and_authorize_resource
  

  # GET /ratings
  # GET /ratings.json
  def index
    if params[:book_id]
      @ratings = Rating.where(state: 'approved', book_id: params[:book_id]) 
    elsif params[:customer_id] 
      @ratings = Rating.where(
        state: 'approved', customer_id: params[:customer_id]) 
    end
  end

  # GET /ratings/1
  # GET /ratings/1.json
  def show
  end

  # GET /ratings/new
  def new
    @book = Book.find(params[:book_id])
    @rating = Rating.new(book: @book, customer: current_customer)
  end

  # GET /ratings/1/edit
  def edit
    @book = Book.find(@rating.book_id)
  end

  # POST /ratings
  # POST /ratings.json
  def create
    @book = Book.find(rating_params[:book_id])
    @rating = Rating.new(rating_params)
    @rating.customer = current_customer

    respond_to do |format|
      if @rating.save
        format.html { redirect_to @rating, notice: NOTICE_CREATE_SUCCESS }
        format.json { render :show, status: :created, location: @rating }
      else
        format.html { render :new }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    # @rating = Rating.find(params[:id])
    @rating.state = 'pending'
    respond_to do |format|
      if @rating.update(rating_params)

        format.html { redirect_to @rating, notice: NOTICE_UPDATE_SUCCESS }
        format.json { render :show, status: :ok, location: @rating }
      else
        format.html { render :edit }
        format.json { 
          render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { 
        redirect_to book_url(@rating.book), notice: NOTICE_DESTROY_SUCCESS }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:id, :rate, :review, :book_id)
    end

    # def authenticate_customer_if_exists
    #   authenticate_customer! if params[:customer_id]
    # end
end
