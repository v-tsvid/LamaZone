require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { FactoryGirl.create :book }

  [:title, :price, :books_in_stock].each do |item|
    it "is invalid without #{item}" do
      expect(book).to validate_presence_of item
    end
  end
  
  it "is valid only when price is numerical and greater than 0" do
    expect(book).to validate_numericality_of(:price).
      is_greater_than 0
  end

  it "is valid only when books_in_stock is numerical, integer 
    and greater than or equal 0" do
    expect(book).to validate_numericality_of(:books_in_stock).
      is_greater_than_or_equal_to(0).only_integer
  end

  it "belongs to author" do
    expect(book).to belong_to :author
  end

  it "has many ratings" do
    expect(book).to have_many :ratings
  end

  it "has and belongs to many categories" do
    expect(book).to have_and_belong_to_many :categories
  end

  context ".title_by_id" do
    it "returns book title if book was found by id passed" do
      expect(Book.title_by_id(book.id)).to eq book.title
    end

    it "returns nil if book was not found" do
      expect(Book.title_by_id(book.id + 1)).to eq nil
    end
  end

  context ".of_category" do
    before do
      @best_book = FactoryGirl.create(:bestseller_book)
      @other_books = FactoryGirl.create_list(:book, 2)
    end

    subject { Book.of_category('bestsellers') }

    it "returns books belongs to certain category" do
      expect(subject).to match_array [@best_book]
    end

    it "doesn't return books doesn't belong to certain category" do
      expect(subject).not_to match_array @other_books
    end
  end
end
