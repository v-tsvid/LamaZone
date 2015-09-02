require "rails_helper"

RSpec.describe ShoppingCartItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/shopping_cart_items").to route_to("shopping_cart_items#index")
    end

    it "routes to #new" do
      expect(:get => "/shopping_cart_items/new").to route_to("shopping_cart_items#new")
    end

    it "routes to #show" do
      expect(:get => "/shopping_cart_items/1").to route_to("shopping_cart_items#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/shopping_cart_items/1/edit").to route_to("shopping_cart_items#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/shopping_cart_items").to route_to("shopping_cart_items#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shopping_cart_items/1").to route_to("shopping_cart_items#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shopping_cart_items/1").to route_to("shopping_cart_items#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shopping_cart_items/1").to route_to("shopping_cart_items#destroy", :id => "1")
    end

  end
end
