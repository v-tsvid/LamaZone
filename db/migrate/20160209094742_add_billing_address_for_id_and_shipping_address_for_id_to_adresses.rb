class AddBillingAddressForIdAndShippingAddressForIdToAdresses < ActiveRecord::Migration
  def change
    add_column :addresses, :billing_address_for_id, :integer
    add_column :addresses, :shipping_address_for_id, :integer
  end
end
