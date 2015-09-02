require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { FactoryGirl.build :country }
  
  [:name, :alpha2].each do |item|
    it "is invalid without #{item}" do
      expect(country).to validate_presence_of item
    end

    it "does not allow duplicate #{item}" do
      expect(country).to validate_uniqueness_of item
    end
  end

  context "with alpha2 regex" do
    ["ua", "UAU", "U", "U1", "U!"].each do |item|
      it "is invalid when alpha2 is \"#{item}\"" do
        expect(country).not_to allow_value(item).for(:alpha2).
        with_message(Country::INVALID_ALPHA2_REGEX_MESSAGE)
      end
    end

    it "is valid when alpha2 contains two capitals only" do
      expect(country).to allow_value("XX").for(:alpha2)
    end  
  end

  
end
