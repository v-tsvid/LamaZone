require 'rails_helper'

RSpec.describe "addresses/show", type: :view do
  let(:country) { FactoryGirl.create :country}

  before(:each) do
    @address = assign(:address, Address.create!(
      :phone => "380930000000",
      :address1 => "Address1",
      :address2 => "Address2",
      :city => "City",
      :zipcode => "Zipcode",
      :country_id => country.id
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Address1/)
    expect(rendered).to match(/Address2/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Zipcode/)
  end
end
