require 'rails_helper'

RSpec.describe "credit_cards/show", type: :view do
  before(:each) do
    @credit_card = assign(:credit_card, CreditCard.create!(
      :number => "5168 7423 2791 0638",
      :cvv => "123",
      :expiration_month => "01",
      :expiration_year => "2016",
      :firstname => "Firstname",
      :lastname => "Lastname"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/5168 7423 2791 0638/)
    expect(rendered).to match(/123/)
    expect(rendered).to match(/01/)
    expect(rendered).to match(/2016/)
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/Lastname/)
  end
end
