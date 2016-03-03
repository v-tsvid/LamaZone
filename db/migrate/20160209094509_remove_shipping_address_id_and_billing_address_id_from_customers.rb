class RemoveShippingAddressIdAndBillingAddressIdFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :shipping_address_id
    remove_column :customers, :billing_address_id
  end
end
