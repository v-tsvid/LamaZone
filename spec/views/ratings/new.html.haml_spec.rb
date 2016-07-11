require 'rails_helper'

RSpec.describe "ratings/new", type: :view do
  before(:each) do
    @author = FactoryGirl.create :author
    @book = stub_model(Book, author_id: @author.id)
    assign(:rating, stub_model(Rating, 
                    book_id: @book.id)).as_new_record
    render
  end

  it "renders _form partial" do
    expect(view).to render_template(partial: '_form')
  end

  it "displays link to @book" do
    expect(rendered).to have_selector(
      "a[href=\"#{book_path(@book)}\"]", text: @book.decorate.title_author)
  end
end
