require 'rails_helper'

RSpec.describe "order_items/edit", type: :view do
  before(:each) do
    @order_item = assign(:order_item, OrderItem.create!(
      :price => "9.99",
      :quantity => 1
    ))
  end

  it "renders the edit order_item form" do
    render

    assert_select "form[action=?][method=?]", order_item_path(@order_item), "post" do

      assert_select "input#order_item_price[name=?]", "order_item[price]"

      assert_select "input#order_item_quantity[name=?]", "order_item[quantity]"
    end
  end
end
