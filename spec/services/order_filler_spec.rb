require 'rails_helper'

RSpec.describe OrderFiller do
  let(:order) { FactoryGirl.create :order }
  let(:order_items) { FactoryGirl.create_list :order_item, 3 }

  subject { OrderFiller.new(order) }

  describe "#initialize" do
    it "assigns order passed as @order" do
      subject
      expect(subject.instance_variable_get(:@order)).to eq order
    end
  end

  describe "#add_items_to_order" do
    it "assigns @order.order_items" do
      subject.add_items_to_order(order_items)
      expect(subject.instance_variable_get(:@order).order_items).
        to eq_to_items(order_items)
    end

    it "returns @order" do
      subject
      expect(subject.add_items_to_order(order_items)).to eq(
        subject.instance_variable_get(:@order))
    end
  end
end