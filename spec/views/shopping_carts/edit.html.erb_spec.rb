require 'rails_helper'

RSpec.describe "shopping_carts/edit", type: :view do
  before(:each) do
    @shopping_cart = assign(:shopping_cart, ShoppingCart.create!())
  end

  it "renders the edit shopping_cart form" do
    render

    assert_select "form[action=?][method=?]", shopping_cart_path(@shopping_cart), "post" do
    end
  end
end
