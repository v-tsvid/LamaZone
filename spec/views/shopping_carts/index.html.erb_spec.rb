require 'rails_helper'

RSpec.describe "shopping_carts/index", type: :view do
  before(:each) do
    assign(:shopping_carts, [
      ShoppingCart.create!(),
      ShoppingCart.create!()
    ])
  end

  it "renders a list of shopping_carts" do
    render
  end
end
