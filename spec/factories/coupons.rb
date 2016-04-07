FactoryGirl.define do
  factory :coupon do
    sequence(:code, 90000)
    discount { rand(1..60) }
  end

end
