require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { FactoryGirl.create :country }

  it "is invalid without title" do
    expect(FactoryGirl.build :country, name: nil).not_to be_valid
  end

  it "does not allow duplicate titles" do
    expect(FactoryGirl.build :country, name: country.name).not_to be_valid
  end
end
