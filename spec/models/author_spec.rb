require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:author) { FactoryGirl.create :author }

  [:firstname, :lastname].each do |item|
    it "is invalid without #{item}" do
      expect(FactoryGirl.build :author, "#{item}": nil).not_to be_valid
    end
  end


end
