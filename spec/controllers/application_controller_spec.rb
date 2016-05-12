require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller {}

  describe "#current_order" do
    let(:customer) { FactoryGirl.create :customer }
    let(:order) { FactoryGirl.create :order }

    context "if there is current_customer" do
    
      before do 
        allow(controller).to receive(:current_customer).and_return customer
        allow_any_instance_of(Customer).to receive(
          :current_order_of_customer).and_return(order)
      end

      it "returns current order of current customer" do
        expect(controller.current_order).to eq order
      end
    end

    context "if there is no current_customer" do

      before { allow(controller).to receive(:current_customer).and_return nil }

      it "returns nil" do
        expect(controller.current_order).to eq nil
      end
    end
  end
end