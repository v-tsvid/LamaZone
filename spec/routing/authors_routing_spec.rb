require "rails_helper"

RSpec.describe AuthorsController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/authors/1").to route_to("authors#show", :id => "1")
    end
  end
end
