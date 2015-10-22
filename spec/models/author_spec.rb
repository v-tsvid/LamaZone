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

  context "#custom_label_method" do
    it "returns string with lastname and firstname" do
      expect(author.send(:custom_label_method)).
        to eq "#{author.lastname} #{author.firstname}"
    end
  end

  context "#full_name" do
    it "returns string wih lastname joined to firstname" do
      expect(author.send(:full_name)).
        to eq "#{author.firstname} #{author.lastname}"
    end
  end
end
