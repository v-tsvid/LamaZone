class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]

  def push_to_cookies
    order_items = read_from_cookies
    order_items << OrderItem.new(book_id: params[:book_id], quantity: params[:quantity])
    write_to_cookies(order_items)

    redirect_to :back, notice: "\"#{Book.find(params[:book_id]).title}\" " \
                           "was added to cart"
  end

  def pop_from_cookies
    order_items = read_from_cookies

    order_items.each do |item|
      if item.book_id.to_s == params[:book_id] && 
         item.quantity.to_s == params[:quantity]
        order_items.delete(item) 
      end
    end

    write_to_cookies(order_items)

    redirect_to :back, notice: "\"#{Book.find(params[:book_id]).title}\" " \
                           "was removed from cart"
  end

  # GET /order_items
  # GET /order_items.json
  def index
    @order_items = read_from_cookies
  end

  # GET /order_items/1
  # GET /order_items/1.json
  # def show
  # end

  # GET /order_items/new
  # def new
  #   @order_item = OrderItem.new
  # end

  # GET /order_items/1/edit
  # def edit
  # end

  # POST /order_items
  # POST /order_items.json
  # def create
  #   @order_item = OrderItem.new(order_item_params)

  #   respond_to do |format|
  #     if @order_item.save
  #       format.html { redirect_to @order_item, notice: 'Order item was successfully created.' }
  #       format.json { render :show, status: :created, location: @order_item }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @order_item.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /order_items/1
  # PATCH/PUT /order_items/1.json
  # def update
  #   respond_to do |format|
  #     if @order_item.update(order_item_params)
  #       format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @order_item }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @order_item.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /order_items/1
  # DELETE /order_items/1.json
  # def destroy
  #   @order_item.destroy
  #   respond_to do |format|
  #     format.html { redirect_to order_items_url, notice: 'Order item was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_item_params
      params.require(:order_item).permit(:price, :quantity, :book_id)
    end

    def write_to_cookies(items)
      cookies[:order_items] = ''
      items.each do |item|
        cookies[:order_items] = { value: [cookies[:order_items],
                                          item[:book_id],
                                          item[:quantity]].join(' '),
                                  expires: 30.days.from_now }
      end
    end

    def read_from_cookies
      order_items = Array.new

      cookies[:order_items].split(' ').
        partition.with_index{ |v, index| index.even? }.transpose.each do |item|
          order_items << OrderItem.new(book_id: item[0], quantity: item[1])
      end

      order_items = order_items.group_by{|h| h.book_id}.values.map do |a| 
        OrderItem.new(book_id: a.first.book_id, 
                      quantity: a.inject(0){|sum,h| sum + h.quantity})
      end

      order_items.each do |item| 
        item.price = Book.find(item.book_id).price * item.quantity
      end
    end
end
