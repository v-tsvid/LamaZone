require 'rails_helper'

RSpec.describe "ratings/show", type: :view do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @book = FactoryGirl.create :book
    @rating = FactoryGirl.create :rating, 
              book_id: @book.id, 
              customer_id: @customer.id
  end

  context "for authorized customers" do
    before do
      sign_in @customer
      render
    end

    it "displays link to all customer's ratings" do
      expect(rendered).to have_selector(
        "a[href=\"#{customer_ratings_path(@customer)}\"]", text: 'Your ratings')
    end    
  end

  context "for unauthorized customers" do
    before { render }
    
    it "doesn't display link to all customer's ratings" do
      expect(rendered).not_to have_content('Your ratings')
    end
  end
end
