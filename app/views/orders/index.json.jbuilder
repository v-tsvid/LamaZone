json.array!(@orders) do |order|
  json.extract! order, :id, :state, :total_price, :completed_date
  json.url order_url(order, format: :json)
end
