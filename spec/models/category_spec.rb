require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { FactoryGirl.create :category }

  it "is invalid without title" do
    expect(category).to validate_presence_of :title
  end

  it "does not allow duplicate titles" do
    expect(category).to validate_uniqueness_of :title
  end

  it "has and belongs to many books" do
    expect(category).to have_and_belong_to_many :books
  end
end
