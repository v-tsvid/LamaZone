require "rails_helper"

RSpec.describe RatingsController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(get: "books/1/ratings/new").
        to route_to("ratings#new", book_id: "1")
    end

    it "routes to #create" do
      expect(post: "books/1/ratings").
        to route_to("ratings#create", book_id: "1")
    end
  end
end
