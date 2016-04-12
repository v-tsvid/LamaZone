class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]

  def update_cart
    @order_items = Array.new
    if current_order
      current_order.order_items.destroy_all
      params[:order_items_attrs].each do |item|
        @order_items << OrderItem.create(
          book_id: item[:book_id], quantity: item[:quantity], order: current_order)
      end
    else
      params[:order_items_attrs].each do |item|
        @order_items << OrderItem.new(
          book_id: item[:book_id], quantity: item[:quantity])
      end
      write_to_cookies(@order_items)
    end

    redirect_to order_items_path
  end

  def empty_cart
    if current_order
      current_order.order_items.destroy_all
      current_order.destroy
    else
      cookies.delete('order_items')
    end
    redirect_to order_items_path
  end

  def add_to_cart
    if current_customer
      order = current_order || Order.new(customer: current_customer)
      order.order_items << OrderItem.create(
        book_id: params[:book_id], quantity: params[:quantity], order: order)
      if order.order_items != compact_order_items(order.order_items)
        temp_items = order.order_items
        order.order_items.each { |item| item.destroy }
        order.order_items << compact_order_items(temp_items)
      end
      
      if order.save!
        redirect_to :back, notice: "\"#{Book.find(params[:book_id]).title}\" " \
                                   "was added to the cart"
      else
        redirect_to :back, notice: "can't save order"
      end
    else
      interact_with_cookies(false)
    end
  end

  def remove_from_cart
    if current_order
      order = current_order
      item = OrderItem.find_by(order_id: current_order.id, 
        book_id: params[:book_id]).destroy
      order.destroy unless order.order_items[0]
      redirect_to :back, notice: "\"#{Book.find(params[:book_id]).title}\" " \
                                 "was removed from the cart"
    else
      interact_with_cookies(true)
    end
  end

  

  # GET /order_items
  # GET /order_items.json
  def index
    if current_order
      @order = current_order
      @order.order_items = compact_order_items(@order.order_items + read_from_cookies)
      cookies.delete('order_items')
    elsif cookies['order_items']
      if current_customer
        @order = Order.create(customer: current_customer, state: 'in_progress')
        @order.order_items = compact_order_items(read_from_cookies)
        cookies.delete('order_items')
      else
        @order = Order.new
        @order.order_items = compact_order_items(read_from_cookies)
      end
    else
      redirect_to root_path, notice: 'Your cart is empty'
    end
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

    def interact_with_cookies(pop)
      order_items = compact_order_items(read_from_cookies)
      order_items = pop ? pop_from_cookies(order_items) : push_to_cookies(order_items)
      write_to_cookies(order_items)    
      added_or_removed = pop ? 'removed from' : 'added to'
      redirect_to :back, notice: "\"#{Book.find(params[:book_id]).title}\" " \
                                 "was #{added_or_removed} cart"
    end

    def push_to_cookies(order_items)
      order_items << OrderItem.new(book_id: params[:book_id], quantity: params[:quantity])
    end

    def pop_from_cookies(order_items)
      order_items.each do |item|
        order_items.delete(item) if item.book_id.to_s == params[:book_id]
      end
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
      if cookies[:order_items]
        cookies[:order_items].split(' ').
          partition.with_index{ |v, index| index.even? }.transpose.each do |item|
            order_items << OrderItem.new(book_id: item[0], quantity: item[1])
        end
      end
      order_items
    end
end
