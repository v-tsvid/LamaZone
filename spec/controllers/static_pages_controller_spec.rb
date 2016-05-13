require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  before do
    @best_books = FactoryGirl.create_list :book, 2
    @other_book = FactoryGirl.create :book
    allow(Book).to receive(:books_of_category).with('bestsellers').
      and_return @best_books
  end

  describe "GET #home" do

    it "receives :books_of_category on Book" do
      expect(Book).to receive(:books_of_category).with('bestsellers')
      get :home
    end

    it "assigns books of the bestsellers category as @books" do
      get :home
      expect(assigns(:books)).to match @best_books
      expect(assigns(:books)).not_to match @other_book
    end
  end
end
