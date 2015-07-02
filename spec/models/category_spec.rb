require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { FactoryGirl.create :category }

  it "is invalid without title" do
    expect(FactoryGirl.build :category, title: nil).not_to be_valid
  end

  it "does not allow duplicate titles" do
    expect(FactoryGirl.build :category, title: category.title).not_to be_valid
  end
end
