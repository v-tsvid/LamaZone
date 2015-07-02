require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { FactoryGirl.create :book }

  [:title, :price, :books_in_stock].each do |item|
    it "is invalid without #{item}" do
      expect(FactoryGirl.build :book, "#{item}": nil).not_to be_valid
    end
  end
end
