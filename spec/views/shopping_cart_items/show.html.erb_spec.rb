require 'rails_helper'

RSpec.describe "shopping_cart_items/show", type: :view do
  before(:each) do
    @shopping_cart_item = assign(:shopping_cart_item, ShoppingCartItem.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
