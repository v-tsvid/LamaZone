require 'rails_helper'

RSpec.describe "ratings/edit", type: :view do
  before(:each) do
    @customer = FactoryGirl.create :customer
    @book = FactoryGirl.create :book
    @rating = FactoryGirl.create :rating, 
              book_id: @book.id, 
              customer_id: @customer.id
    sign_in @customer
    render
  end
  
  context "for authorized customers" do
    it "renders _form partial" do
      expect(view).to render_template(partial: '_form')
    end

    it "displays link to all customer's ratings" do
      expect(rendered).to have_selector(
        "a[href=\"#{customer_ratings_path(@customer)}\"]", text: 'Your ratings')
    end  
  end
end
