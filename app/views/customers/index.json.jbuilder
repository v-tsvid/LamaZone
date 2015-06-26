json.array!(@customers) do |customer|
  json.extract! customer, :id, :email, :password, :password_confirmation, :firstname, :lastname
  json.url customer_url(customer, format: :json)
end
