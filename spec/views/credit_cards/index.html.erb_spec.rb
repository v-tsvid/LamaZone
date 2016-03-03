require 'rails_helper'

RSpec.describe "credit_cards/index", type: :view do
  before(:each) do
    assign(:credit_cards, [
      CreditCard.create!(
        :number => "5168 7423 2791 0638",
        :cvv => "123",
        :expiration_month => "01",
        :expiration_year => "2017",
        :firstname => "Firstname",
        :lastname => "Lastname"
      ),
      CreditCard.create!(
        :number => "5168 7423 2791 0638",
        :cvv => "123",
        :expiration_month => "01",
        :expiration_year => "2017",
        :firstname => "Firstname",
        :lastname => "Lastname"
      )
    ])
  end

  it "renders a list of credit_cards" do
    render
    assert_select "tr>td", :text => "5168 7423 2791 0638".to_s, :count => 2
    assert_select "tr>td", :text => "123".to_s, :count => 2
    assert_select "tr>td", :text => "01".to_s, :count => 2
    assert_select "tr>td", :text => "2017".to_s, :count => 2
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
  end
end
