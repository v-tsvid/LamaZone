require 'rails_helper'

RSpec.describe "shopping_cart_items/edit", type: :view do
  before(:each) do
    @shopping_cart_item = assign(:shopping_cart_item, ShoppingCartItem.create!())
  end

  it "renders the edit shopping_cart_item form" do
    render

    assert_select "form[action=?][method=?]", shopping_cart_item_path(@shopping_cart_item), "post" do
    end
  end
end
