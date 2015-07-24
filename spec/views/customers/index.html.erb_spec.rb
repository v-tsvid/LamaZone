require 'rails_helper'

RSpec.describe "customers/index", type: :view do
  before(:each) do
    assign(:customers, [
      Customer.create!(
        :email => "MyString1@mail.com",
        :password => "Password",
        :password_confirmation => "Password",
        :firstname => "Firstname",
        :lastname => "Lastname"
      ),
      Customer.create!(
        :email => "MyString2@mail.com",
        :password_confirmation => "Password",
        :password => "Password",
        :firstname => "Firstname",
        :lastname => "Lastname"
      )
    ])
  end

  it "renders a list of customers" do
    render
    assert_select "tr>td", :text => "mystring1@mail.com".to_s, :count => 1
    assert_select "tr>td", :text => "mystring2@mail.com".to_s, :count => 1
    assert_select "tr>td", :text => "Password".to_s, :count => 4
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
  end
end
