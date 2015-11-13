require 'rails_helper'

RSpec.describe "ratings/show", type: :view do
  before(:each) do
    @customer = stub_model(Customer)
    @author = FactoryGirl.create :author
    @book = stub_model(Book, author_id: @author.id)
    assign(:rating, stub_model(Rating, 
                    book_id: @book.id, 
                    customer_id: @customer.id))
  end

  context "for authorized customers" do
    before do
      allow(controller).to receive(:current_user)
      render
    end

    it "displays link to books" do
      expect(rendered).to have_selector(
        "a[href=\"/books\"]", text: 'Back to books')
    end     
  end

  context "for unauthorized customers" do
    before { render }
    
    it "doesn't display link to all customer's ratings" do
      expect(rendered).not_to have_content('Your ratings')
    end
  end
end
