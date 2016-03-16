require 'rails_helper'

RSpec.describe "books/show", type: :view do

  before do 
    @book = assign(:book, FactoryGirl.create(:book))
    @ratings = [
      FactoryGirl.create(:rating, book: @book, state: 'approved', rate: 5),
      FactoryGirl.create(:rating, book: @book, state: 'pending', rate: 10)]
    
    @book.ratings << @ratings
  end

  context "book information displaying" do

    before { render }

    [:title, :price].each do |item|
      it "displays book #{item}" do
        expect(rendered).to have_content @book.send(item)
      end
    end

    it "displays book author's firstname and lastname" do
      expect(rendered).to have_content @book.author.send(:full_name)
    end

    it "displays books quantity customer is going to buy" do
      expect(rendered).to have_selector "[type='number'][id='book_quantity']"
    end

    it "displays 'add to cart' button" do
      expect(rendered).to have_button 'Add to Cart'
    end
  end

  context "only approved book ratings displaying" do
    before do
      render
    end

    it "renders _book_ratings partial" do
      expect(view).to render_template(partial: '_rating', count: @book.ratings.count)
    end

    context "for approved rating" do

      subject { @book.ratings[0] }

      it "displays rating rate" do
        expect(rendered).to have_content subject.rate.to_s
      end

      it "displays rating review" do
        expect(rendered).to have_content(
          truncate(
            subject.review.to_s, length: 100, separator: ' ', omission: ''))
      end

      it "displays rating customer name" do
        expect(rendered).to have_content(subject.customer.send(:full_name))
      end
    end

    context "for not approved rating" do
      subject { @book.ratings[1] }

      it "does not display rating rate" do
        expect(rendered).not_to have_content subject.rate.to_s
      end

      it "does not display rating review" do
        expect(rendered).not_to have_content(
          truncate(
            subject.review.to_s, length: 100, separator: ' ', omission: ''))
      end

      it "does not display rating customer name" do
        expect(rendered).not_to have_content(subject.customer.send(:full_name))
      end
    end
  end
end
