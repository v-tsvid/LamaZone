require 'rails_helper'

RSpec.describe "credit_cards/new", type: :view do
  before(:each) do
    assign(:credit_card, CreditCard.new(
      :number => "5168 7423 2791 0638",
      :cvv => "123",
      :expiration_month => "01",
      :expiration_year => "2016",
      :firstname => "MyString",
      :lastname => "MyString"
    ))
  end

  it "renders new credit_card form" do
    render

    assert_select "form[action=?][method=?]", credit_cards_path, "post" do

      assert_select "input#credit_card_number[name=?]", "credit_card[number]"

      assert_select "input#credit_card_cvv[name=?]", "credit_card[cvv]"

      assert_select "input#credit_card_expiration_month[name=?]", "credit_card[expiration_month]"

      assert_select "input#credit_card_expiration_year[name=?]", "credit_card[expiration_year]"

      assert_select "input#credit_card_firstname[name=?]", "credit_card[firstname]"

      assert_select "input#credit_card_lastname[name=?]", "credit_card[lastname]"
    end
  end
end
