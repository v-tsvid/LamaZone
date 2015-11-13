require "rails_helper"

RSpec.describe RatingsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "books/1/ratings").to route_to("ratings#index", book_id: "1")
      # expect(get: "customers/1/ratings").
      #   to route_to("ratings#index", customer_id: "1")
    end

    it "routes to #new" do
      expect(get: "books/1/ratings/new").
        to route_to("ratings#new", book_id: "1")
    end

    it "routes to #edit" do
      expect(get: "ratings/1/edit").to route_to("ratings#edit", id: "1")
    end

    it "routes to #show" do
      expect(get: "/ratings/1").to route_to("ratings#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "books/1/ratings").
        to route_to("ratings#create", book_id: "1")
    end

    it "routes to #destroy" do
      expect(delete "ratings/1").to route_to("ratings#destroy", id: "1")
    end

  end
end
