require 'rails_helper'

RSpec.describe "coupons/edit", type: :view do
  before(:each) do
    @coupon = assign(:coupon, Coupon.create!(
      :code => "MyString",
      :discount => 1
    ))
  end

  it "renders the edit coupon form" do
    render

    assert_select "form[action=?][method=?]", coupon_path(@coupon), "post" do

      assert_select "input#coupon_code[name=?]", "coupon[code]"

      assert_select "input#coupon_discount[name=?]", "coupon[discount]"
    end
  end
end
