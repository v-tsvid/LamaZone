require "rails_helper"

RSpec.describe OrderItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/cart").to route_to("order_items#index")
    end
  end
end
