require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { FactoryGirl.create :book }

  [:title, :price, :books_in_stock].each do |item|
    it "is invalid without #{item}" do
      expect(book).to validate_presence_of item
    end
  end

  [:author, :category].each do |item|
    it "belongs to #{item}" do
      expect(book).to belong_to item
    end
  end

  it "has many ratings" do
    expect(book).to have_many :ratings
  end
end
