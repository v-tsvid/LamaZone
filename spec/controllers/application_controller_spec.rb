require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller {}

  describe "#current_order" do
    before do
      @order = FactoryGirl.build :order
      # cookies[:order_items] = nil
    end

    # it "puts to cookies[:order_items] an empty array" do
    #   controller.current_order
    #   expect(cookies[:order_items]).to eq []
    # end

    context "if there is an order in the cookies" do
    
      before { cookies[:order] = @order }

      it "returns cookies[:order]" do
        expect(controller.current_order).to eq @order
      end
    end

    context "if there is no order in the cookies" do

      before do
        allow(Order).to receive(:new).and_return(@order)
        cookies[:order] = nil
      end

      it "returns cookies[:order] as a new order JSON serialized attributes" do
        expect(controller.current_order).to eq JSON.generate(@order.attributes)
      end
    end
  end
end