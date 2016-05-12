require "rails_helper"

RSpec.describe AddressesController, type: :routing do
  describe "routing" do

    it "routes to #create" do
      expect(:post => "addresses").
        to route_to("addresses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/addresses/1").to route_to("addresses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/addresses/1").to route_to("addresses#update", :id => "1")
    end
  end
end
