require 'rails_helper'

RSpec.describe "credit_cards/edit", type: :view do
  before(:each) do
    @credit_card = assign(:credit_card, CreditCard.create!(
      :number => "5168 7423 2791 0638",
      :cvv => "123",
      :expiration_month => "01",
      :expiration_year => "2017",
      :firstname => "MyString",
      :lastname => "MyString"
    ))
  end

  it "renders the edit credit_card form" do
    render

    assert_select "form[action=?][method=?]", credit_card_path(@credit_card), "post" do

      assert_select "input#credit_card_number[name=?]", "credit_card[number]"

      assert_select "input#credit_card_cvv[name=?]", "credit_card[cvv]"

      assert_select "input#credit_card_expiration_month[name=?]", "credit_card[expiration_month]"

      assert_select "input#credit_card_expiration_year[name=?]", "credit_card[expiration_year]"

      assert_select "input#credit_card_firstname[name=?]", "credit_card[firstname]"

      assert_select "input#credit_card_lastname[name=?]", "credit_card[lastname]"
    end
  end
end
