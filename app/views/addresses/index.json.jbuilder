json.array!(@addresses) do |address|
  json.extract! address, :id, :phone, :address1, :address2, :city, :zipcode, :country
  json.url address_url(address, format: :json)
end
