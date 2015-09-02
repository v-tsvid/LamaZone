require 'rails_helper'

RSpec.describe "shopping_carts/new", type: :view do
  before(:each) do
    assign(:shopping_cart, ShoppingCart.new())
  end

  it "renders new shopping_cart form" do
    render

    assert_select "form[action=?][method=?]", shopping_carts_path, "post" do
    end
  end
end
