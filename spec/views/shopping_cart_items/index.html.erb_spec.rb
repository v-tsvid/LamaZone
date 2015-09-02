require 'rails_helper'

RSpec.describe "shopping_cart_items/index", type: :view do
  before(:each) do
    assign(:shopping_cart_items, [
      ShoppingCartItem.create!(),
      ShoppingCartItem.create!()
    ])
  end

  it "renders a list of shopping_cart_items" do
    render
  end
end
