require 'rails_helper'

RSpec.describe "credit_cards/show", type: :view do
  before(:each) do
    @credit_card = assign(:credit_card, CreditCard.create!(
      :number => "Number",
      :cvv => "Cvv",
      :expiration_month => "Expiration Month",
      :expiration_year => "Expiration Year",
      :firstname => "Firstname",
      :lastname => "Lastname"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Number/)
    expect(rendered).to match(/Cvv/)
    expect(rendered).to match(/Expiration Month/)
    expect(rendered).to match(/Expiration Year/)
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/Lastname/)
  end
end
