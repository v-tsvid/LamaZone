require 'rails_helper'

RSpec.describe "shopping_cart_items/new", type: :view do
  before(:each) do
    assign(:shopping_cart_item, ShoppingCartItem.new())
  end

  it "renders new shopping_cart_item form" do
    render

    assert_select "form[action=?][method=?]", shopping_cart_items_path, "post" do
    end
  end
end
