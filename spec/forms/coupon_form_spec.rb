require 'rails_helper'

RSpec.describe CouponForm, type: :model do
  let(:coupon) { FactoryGirl.create :coupon, code: '90009' }
  let(:coupon_form) { CouponForm.new(coupon) }
  subject { coupon_form }

  [:code, :discount].each do |item|
    it { is_expected.to respond_to item }
    it { is_expected.to validate_presence_of item }
  end

  it { is_expected.to validate_inclusion_of(:discount).in_array(Array(1..99)) }
end