require 'rails_helper'

RSpec.describe "addresses/new", type: :view do
  let(:country) { FactoryGirl.create :country}

  before(:each) do
    assign(:address, Address.new(
      :phone => "380930000000",
      :address1 => "MyString",
      :address2 => "MyString",
      :city => "MyString",
      :zipcode => "MyString",
      :country_id => country.id
    ))
  end

  it "renders new address form" do
    render

    assert_select "form[action=?][method=?]", addresses_path, "post" do

      assert_select "input#address_phone[name=?]", "address[phone]"

      assert_select "input#address_address1[name=?]", "address[address1]"

      assert_select "input#address_address2[name=?]", "address[address2]"

      assert_select "input#address_city[name=?]", "address[city]"

      assert_select "input#address_zipcode[name=?]", "address[zipcode]"
    end
  end
end
