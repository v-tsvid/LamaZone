require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:author) { FactoryGirl.create :author }

  [:firstname, :lastname].each do |item|
    it "is invalid without #{item}" do
      expect(author).to validate_presence_of item
    end
  end

  it "has many books" do
    expect(author).to have_many :books
  end
end
