module AddressesHelper
  def countries_for_select
    Country.all.map {|country| [country.name, country.id]}
  end
end
