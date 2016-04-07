json.array!(@coupons) do |coupon|
  json.extract! coupon, :id, :code, :discount
  json.url coupon_url(coupon, format: :json)
end
