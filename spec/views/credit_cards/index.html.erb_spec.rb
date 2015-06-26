require 'rails_helper'

RSpec.describe "credit_cards/index", type: :view do
  before(:each) do
    assign(:credit_cards, [
      CreditCard.create!(
        :number => "Number",
        :cvv => "Cvv",
        :expiration_month => "Expiration Month",
        :expiration_year => "Expiration Year",
        :firstname => "Firstname",
        :lastname => "Lastname"
      ),
      CreditCard.create!(
        :number => "Number",
        :cvv => "Cvv",
        :expiration_month => "Expiration Month",
        :expiration_year => "Expiration Year",
        :firstname => "Firstname",
        :lastname => "Lastname"
      )
    ])
  end

  it "renders a list of credit_cards" do
    render
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => "Cvv".to_s, :count => 2
    assert_select "tr>td", :text => "Expiration Month".to_s, :count => 2
    assert_select "tr>td", :text => "Expiration Year".to_s, :count => 2
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
  end
end
