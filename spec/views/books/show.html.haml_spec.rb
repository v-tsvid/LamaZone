require 'rails_helper'

RSpec.describe "books/show", type: :view do

  before { @book = assign(:book, FactoryGirl.create(:book_with_ratings)) }

  [:title, :price, :books_in_stock].each do |item|
    it "displays book #{item}" do
      render
      expect(rendered).to match @book.send(item).to_s
    end
  end

  it "displays book author's firstname and lastname" do
    render
    expect(rendered).to match @book.author.send(:full_name)
  end
  
  it "displays approved book ratings only" do
    render
    @book.ratings.each do |rating|
      if rating.state == 'approved'
        expect(rendered).to match rating.rate.to_s
        expect(rendered).to match(
          truncate(
            rating.review.to_s, length: 100, separator: ' ', omission: ''))
        expect(rendered).to match(
          Customer.find(rating.customer_id).send(:full_name))
      else
        rating.review = 'review for unapproved rating'
        expect(rendered).not_to match(
          truncate(
            rating.review.to_s, length: 100, separator: ' ', omission: ''))
      end
    end
  end

  it "renders _book_ratings partial" do
    render
    expect(view).to render_template(partial: '_rating', count: @book.ratings.count)
  end
end
