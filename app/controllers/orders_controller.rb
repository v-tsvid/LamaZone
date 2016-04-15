class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # # GET /orders
  # # GET /orders.json
  def index
  end

  # # GET /orders/1
  # # GET /orders/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:state, :total_price, :completed_date)
    end
end
