require 'rails_helper'

RSpec.describe OrderItemForm, type: :model do
  let(:order_item) { FactoryGirl.create :order_item }
  let(:order_item_form) { OrderItemForm.new(order_item) }
  subject { order_item_form }

  [:price, :quantity, :book, :order].each do |item|
    it { is_expected.to respond_to item }
    it { is_expected.to validate_presence_of item }
  end

  [:price, :quantity].each do |item|
    it { is_expected.to validate_numericality_of(item) }
  end
end