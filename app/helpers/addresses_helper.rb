module AddressesHelper
  def countries_for_select
    Country.all.map {|country| [country.name, country.id]}
  end

  def address_errors_list(errors, addr, attr_sym)
    "#{errors["#{addr}.#{attr_sym}"].uniq.join(', ')}"
  end

  def addresses_is_equal?(billing_address, shipping_address)
    billing_address && shipping_address && 
    billing_address.attributes_short == shipping_address.attributes_short && 
    !flash[:errors]
  end

  def nil_addresses
    {'billing_address' => nil, 'shipping_address' => nil }
  end
end
