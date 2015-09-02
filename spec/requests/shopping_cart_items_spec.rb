require 'rails_helper'

RSpec.describe "ShoppingCartItems", type: :request do
  describe "GET /shopping_cart_items" do
    it "works! (now write some real specs)" do
      get shopping_cart_items_path
      expect(response).to have_http_status(200)
    end
  end
end
