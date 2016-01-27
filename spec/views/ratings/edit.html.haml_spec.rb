require 'rails_helper'

RSpec.describe "ratings/edit", type: :view do
  before(:each) do
    @customer = stub_model(Customer)
    @author = FactoryGirl.create :author
    @book = stub_model(Book, author_id: @author.id)
    assign(:rating, stub_model(Rating, 
                    book_id: @book.id, 
                    customer_id: @customer.id))
    allow(controller).to receive(:current_customer).and_return(@customer)
    render
  end

  subject { assigns(:rating) }
  
  context "for authorized customers" do
    it "renders _form partial" do
      expect(view).to render_template(partial: '_form')
    end

    it "displays link to books" do
      expect(rendered).to have_selector(
        "a[href=\"/books\"]", text: 'Back to books')
    end  
  end
end
