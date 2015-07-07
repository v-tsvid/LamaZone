require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { FactoryGirl.create :country }

  it "is invalid without name" do
    expect(country).to validate_presence_of :name
  end

  it "does not allow duplicate names" do
    expect(country).to validate_uniqueness_of :name
  end
end
